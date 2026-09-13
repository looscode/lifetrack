# LifeTrack

A minimalist life counter for Magic: The Gathering, with Commander damage
and poison-counter tracking built in. Pure HTML/CSS/JS, zero dependencies,
zero build step, works fully offline.

## What's here

```
index.html      the app itself (all HTML/CSS/JS in one file)
manifest.json   name/icon/display settings so it can be installed as an app
sw.js           service worker — caches the app so it works with no signal
icons/          home-screen icons
```

## Running it locally

No build step, no install. Just serve the folder:

```
python3 -m http.server 8000
```

Then open `http://localhost:8000` in a browser. Editing `index.html` and
refreshing is the whole dev loop.

You can also just double-click `index.html` to open it directly — the app
itself works fine that way. The only thing that needs an actual server is
testing the "installable" / offline behavior (see below), since browsers
only allow service workers on `http://localhost` or real HTTPS, not on a
plain `file://` path.

## Installing it on your phone (no app store)

- **iPhone (Safari)**: open `index.html` in Safari → Share → "Add to Home
  Screen." Works immediately, no server needed, launches full-screen.
- **Android (Chrome)**: Chrome only grants a true full-screen install from a
  "secure" origin, which a `file://` path doesn't count as. Serve the folder
  locally (e.g. `python3 -m http.server 8000` run from Termux on the phone
  itself) and open `http://localhost:8000` in Chrome, then "Add to Home
  screen." Everything after that works fully offline.

## Continuing development in Claude Code

This folder is a git repo, ready to open as a project:

```
cd lifetrack
claude
```

A few things worth knowing before making changes:

- **Bump the service worker cache** (`CACHE_NAME` at the top of `sw.js`)
  whenever `index.html`, `manifest.json`, or the icons change. The cache-first
  strategy means a phone that already installed the app won't see updates
  otherwise. Just increment the version suffix, e.g. `lifetrack-v9` →
  `lifetrack-v10`.
- **Everything lives in one `index.html`** by design — no bundler, no
  framework, no npm install. If a change grows the file a lot, it's worth
  asking whether it should stay that way, but for a tool this size the
  single-file approach is what keeps it fast and dependency-free.
- **Test on an actual phone-sized viewport** — most of the layout logic
  (player rotation, cell sizing, tap-zone hit areas) is built around small
  touchscreens, and looks different on a wide desktop window.
- Commit as you go — `git add -A && git commit -m "..."` — so each feature
  is easy to review or roll back independently.

## Design notes

- Colors and layout intentionally avoid the generic "AI app" look (warm
  cream + terracotta, dark mode with one neon accent, SaaS card grids).
  The palette is instead a muted, distinct color per player, and life
  totals render in a monospace face for a physical-scoreboard feel.
- Poison and commander-damage tracking are accessed through a single
  center menu rather than cluttering each player's cell — badges on the
  cells themselves are read-only indicators, shown only once a value is
  non-zero.
