param([int]$Port = 8000)

$root = $PSScriptRoot
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $root on http://localhost:$Port/"

$mime = @{
  '.html'='text/html'; '.js'='application/javascript'; '.json'='application/json';
  '.css'='text/css'; '.png'='image/png'; '.svg'='image/svg+xml'; '.ico'='image/x-icon';
  '.webmanifest'='application/manifest+json'
}

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    try {
      $path = [Uri]::UnescapeDataString($req.Url.AbsolutePath)
      if ($path -eq '/') { $path = '/index.html' }
      $full = Join-Path $root ($path.TrimStart('/'))
      $full = [System.IO.Path]::GetFullPath($full)
      if (-not $full.StartsWith($root) -or -not (Test-Path $full -PathType Leaf)) {
        $res.StatusCode = 404
        $bytes = [Text.Encoding]::UTF8.GetBytes("Not found")
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
      } else {
        $ext = [System.IO.Path]::GetExtension($full)
        $res.ContentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
        $bytes = [System.IO.File]::ReadAllBytes($full)
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
      }
    } catch {
      $res.StatusCode = 500
    } finally {
      $res.OutputStream.Close()
    }
  }
} finally {
  $listener.Stop()
}
