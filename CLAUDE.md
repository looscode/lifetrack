# LifeTrack

Single-file HTML/CSS/JS Magic: The Gathering life counter PWA. No build
step, no framework, no dependencies — everything lives in `index.html`.
See `README.md` for the full picture; this file is the operational
essentials for working in this repo specifically.

## Before you touch anything

- **Bump `CACHE_NAME` in `sw.js`** on every change to `index.html`,
  `manifest.json`, or an icon. The service worker is cache-first — skip
  this and the live site can build successfully while every existing
  visitor (including your own test browser) keeps seeing the old version.
  This has actually happened twice; don't skip it.
- **A push is not verification.** GitHub Pages building successfully only
  means the source deployed — it says nothing about whether a client with
  an already-installed service worker sees it. Check the real behavior
  (e.g. fetch `index.html`/`sw.js` with `cache: 'no-store'` and inspect
  the response, or unregister/clear caches and reload) before calling
  something shipped.
- **Look at UI changes before shipping them**, don't just trace the logic
  on paper — a rotation bug in the seat-glyph feature shipped once because
  it was reasoned through instead of actually opened and looked at.

## Local dev server

Python and Node are not installed on this machine. Use the bundled
PowerShell static server instead:

```
powershell -ExecutionPolicy Bypass -File serve.ps1 -Port 8000
```

`.claude/launch.json` already wires this up as the `lifetrack` preview
config for Claude Code's browser tools.

## Deploy

`git push` to `master` → GitHub Pages auto-rebuilds `looscode/lifetrack`
at https://looscode.github.io/lifetrack/, usually in 30-60s. If a Pages
build sits at "building"/"queued" far longer than that with no error, it's
likely a one-off stuck Actions job (not a real problem with the commit) —
cancel it (`gh run cancel <id>`) and manually re-trigger
(`gh api repos/looscode/lifetrack/pages/builds -X POST`) rather than
waiting it out or repushing.

## Environment quirks on this machine

- `git` and `gh` (GitHub CLI, authenticated as `looscode`) are installed
  via winget but were **not** on PATH for already-running shells at
  install time — prepend explicitly if a bare `git`/`gh` call fails:
  `$env:PATH = "$env:ProgramFiles\Git\cmd;$env:ProgramFiles\GitHub CLI;$env:PATH"`.
  This should resolve itself once the Claude Code app/session is
  restarted after the install; worth a quick bare-command check first.
