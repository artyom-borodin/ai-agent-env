# ai-agent-env

One-shot Ubuntu bootstrap script for an AI coding & browser agent sandbox

## What's included

- **Runtimes & toolchains:** Python (`uv`, `pipx`, `micromamba`), Node.js 22 (`bun`, `deno`, `pnpm`), Go, Rust, Java, Ruby, PHP
- **AI & coding tools:** OpenCode, Claude Code, Gemini CLI, OpenVSCode Server, `git`, `gh`, `docker`
- **Browser & GUI:** Playwright + Chromium/Firefox/WebKit, Puppeteer, `Xvfb`, `xfce4`, `x11vnc`, `noVNC`
- **Docs & media:** LibreOffice, Poppler, Tesseract OCR, Pandoc, Typst, ImageMagick, FFmpeg, Blender, DuckDB

## Usage

Run as `root` inside a clean Ubuntu container or VM:

```bash
chmod +x setup.sh
./setup.sh
```

## Notes

- Requires ~20–25 GB free space and takes 15–30 minutes depending on network/CPU.
- Intended for isolated containers/sandboxes.
- Tested on Ubuntu 24.04, 26.04

