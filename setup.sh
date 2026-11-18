#!/usr/bin/env bash
set -euo pipefail


export DEBIAN_FRONTEND=noninteractive
export CI=true
export PAGER=cat
export GIT_PAGER=cat
export BAT_PAGER=cat
export GIT_TERMINAL_PROMPT=0
export PIP_DISABLE_PIP_VERSION_CHECK=1
export PYTHONDONTWRITEBYTECODE=1
export PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
export RUSTUP_HOME=/opt/rust/rustup
export CARGO_HOME=/opt/rust/cargo
export LC_ALL=C.UTF-8
export LANG=C.UTF-8


ARCH="$(dpkg --print-architecture)"


rm -f /etc/apt/sources.list.d/github-cli.list /etc/apt/sources.list.d/docker.list


apt-get update -y
apt-get install -y ca-certificates curl wget gnupg gnupg2 lsb-release apt-transport-https software-properties-common


install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list


curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || true
chmod a+r /etc/apt/keyrings/docker.asc || true
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list || true


curl -fsSL https://deb.nodesource.com/setup_22.x | bash -


apt-get update -y
apt-get install -y \
  aria2 apt-utils util-linux netbase locales sudo tzdata tini supervisor \
  file unzip zip 7zip tar gzip bzip2 xz-utils zstd bc man-db \
  openssh-client openssh-server rsync rclone socat bash zsh tmux screen direnv less vim nano \
  grep gawk sed coreutils findutils diffutils patch moreutils inotify-tools entr gettext \
  procps psmisc lsof htop btop strace \
  netcat-openbsd iproute2 iputils-ping dnsutils net-tools whois mtr-tiny nmap iptables ipset \
  jq gron tree fzf bat fd-find ripgrep silversearcher-ag shellcheck universal-ctags \
  hyperfine age asciinema tldr httpie \
  build-essential gcc g++ gdb make cmake ninja-build ccache pkg-config \
  clang clangd lld lldb clang-format clang-tidy \
  autoconf automake libtool bison flex re2c nasm yasm swig protobuf-compiler \
  libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  libncurses-dev liblzma-dev tk-dev uuid-dev libgdbm-dev libgdbm-compat-dev \
  libxml2-dev libxmlsec1-dev libxslt1-dev \
  libcurl4-openssl-dev libpq-dev default-libmysqlclient-dev unixodbc-dev \
  libicu-dev libonig-dev libzip-dev libyaml-dev libgmp-dev \
  libgd-dev libjpeg-dev libpng-dev libcairo2-dev libnss3-dev libz3-dev \
  git git-lfs gh \
  python3 python-is-python3 python3-pip python3-venv python3-dev python3-tk pipx \
  nodejs golang-go default-jdk-headless maven gradle ruby-full ruby-dev ruby-bundler \
  php-cli php-curl php-mbstring php-xml php-zip php-gd php-sqlite3 php-pgsql php-mysql composer \
  libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libatspi2.0-0 \
  libcairo2 libcups2 libdbus-1-3 libdrm2 libgbm1 libglib2.0-0 \
  libpango-1.0-0 libx11-6 libxcb1 libxcomposite1 libxdamage1 \
  libxext6 libxfixes3 libxkbcommon0 libxrandr2 libxss1 libfontconfig1 libfreetype6 libgl1 libatomic1 \
  fonts-liberation fonts-noto-color-emoji fonts-unifont fonts-ipafont-gothic fonts-wqy-zenhei \
  fonts-dejavu-core fonts-noto-cjk fonts-crosextra-carlito fonts-crosextra-caladea fonts-lato \
  sqlite3 postgresql-client redis-tools default-mysql-client \
  poppler-utils qpdf ghostscript graphviz pandoc \
  libreoffice-core libreoffice-writer libreoffice-calc libreoffice-impress \
  libreoffice-draw libreoffice-java-common libreoffice-script-provider-python \
  tesseract-ocr tesseract-ocr-eng tesseract-ocr-rus \
  imagemagick ffmpeg sox mediainfo libimage-exiftool-perl libvips-tools pngquant gifsicle chafa \
  libxi6 libxxf86vm1 libxrender1 libegl1 libsm6 libice6 \
  libwayland-client0 libwayland-cursor0 libwayland-egl1 libdecor-0-0 \
  xvfb xserver-xorg x11-xserver-utils x11-utils x11-apps xauth dbus-x11 libgtk-3-bin \
  xfce4 xfce4-goodies xfce4-terminal mutter tint2 pcmanfm galculator xpdf gedit xterm \
  xdotool wmctrl scrot maim gnome-screenshot xclip xsel \
  x11vnc tigervnc-standalone-server novnc websockify


apt-get install -y aggregate unrar-free || true
apt-get install -y glab || true
apt-get install -y pdftk-java || true
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || apt-get install -y docker.io docker-compose-v2 || true
apt-get install -y libasound2t64 libasound2-plugins || apt-get install -y libasound2 libasound2-plugins || true
apt-get remove -y light-locker xfce4-screensaver xfce4-power-manager || true


locale-gen C.UTF-8 en_US.UTF-8 ru_RU.UTF-8 || true
update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8


ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true
ln -sf "$(command -v batcat)" /usr/local/bin/bat || true


git lfs install --system
if [ -z "$(git config --system user.name || true)" ]; then
  git config --system user.name "ai-agent"
  git config --system user.email "agent@localhost"
fi


mkdir -p /etc/docker
[ -f /etc/docker/daemon.json ] || echo '{"mtu": 1450}' > /etc/docker/daemon.json


K8S_VER="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
curl -fsSL "https://dl.k8s.io/release/${K8S_VER}/bin/linux/${ARCH}/kubectl" -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || true
curl -fsSL https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- -b /usr/local/bin || true


curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh
ln -sf /usr/local/bin/uv /bin/uv || true
ln -sf /usr/local/bin/uvx /bin/uvx || true


MAMBA_ARCH="$( [ "${ARCH}" = "arm64" ] && echo "linux-aarch64" || echo "linux-64" )"
curl -Ls "https://micro.mamba.pm/api/micromamba/${MAMBA_ARCH}/latest" | tar -xj -C /usr/local/bin --strip-components=1 bin/micromamba || true


for pkg in poetry ruff flake8 pylint mypy basedpyright black isort pre-commit semgrep weasyprint ocrmypdf litecli pgcli mycli visidata harlequin; do
  PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install "$pkg" --force || true
done


corepack enable
corepack prepare pnpm@latest --activate || true
corepack prepare yarn@1.22.22 --activate || true


curl -fsSL https://bun.sh/install | env BUN_INSTALL="/usr/local" bash
curl -fsSL https://deno.land/install.sh | env DENO_INSTALL="/usr/local" sh || true


npm install -g \
  typescript tsx eslint prettier @biomejs/biome oxlint knip pyright tree-sitter-cli \
  playwright puppeteer @playwright/mcp @mermaid-js/mermaid-cli svgo \
  docx pptxgenjs sharp react react-dom react-icons pdf-lib pdfjs-dist \
  @anthropic-ai/sdk @modelcontextprotocol/sdk @modelcontextprotocol/inspector zod


npm install -g \
  @anthropic-ai/claude-code @agentclientprotocol/claude-agent-acp \
  @agentclientprotocol/codex-acp @google/gemini-cli || true


mkdir -p /etc/claude-code
echo '{"permissions":{"allow":["Edit","Read","Bash"]}}' > /etc/claude-code/managed-settings.json


cat << 'EOF' > /etc/puppeteer-config.json
{
  "args": ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage"]
}
EOF


curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v2.9.0 || true
GOBIN=/usr/local/bin go install github.com/boyter/scc/v3@latest || true
GOBIN=/usr/local/bin go install mvdan.cc/sh/v3/cmd/shfmt@latest || true
GOBIN=/usr/local/bin go install github.com/rs/curlie@latest || true


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="/opt/rust/cargo/bin:/usr/local/bin:$PATH"
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash


for crate in \
  ast-grep ripgrep_all sd just watchexec-cli git-delta difftastic xh htmlq qsv \
  tokei typst-cli eza zoxide du-dust bottom procs hexyl taplo-cli csview \
  typos-cli lychee oha grex resvg pastel oxipng; do
  /opt/rust/cargo/bin/cargo-binstall -y --install-path /usr/local/bin "$crate" || true
done
ln -sf /opt/rust/cargo/bin/* /usr/local/bin/


curl https://mise.run | env MISE_INSTALL_PATH=/usr/local/bin/mise sh


curl -fL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${ARCH}" -o /usr/local/bin/yq
chmod +x /usr/local/bin/yq


curl -fL "https://github.com/TomWright/dasel/releases/latest/download/dasel_linux_${ARCH}" -o /usr/local/bin/dasel
chmod +x /usr/local/bin/dasel


HURL_DEB="$(curl -fsSL https://api.github.com/repos/Orange-OpenSource/hurl/releases/latest | jq -r ".assets[] | select(.name | test(\"${ARCH}\\\\.deb$\")) | .browser_download_url" | head -n1)"
if [ -n "${HURL_DEB}" ]; then
  curl -fL "${HURL_DEB}" -o /tmp/hurl.deb && apt-get install -y /tmp/hurl.deb && rm -f /tmp/hurl.deb
fi


if [ "${ARCH}" = "amd64" ]; then
  GITLEAKS_URL="$(curl -fsSL https://api.github.com/repos/gitleaks/gitleaks/releases/latest | jq -r '.assets[] | select(.name | test("linux_x64\\.tar\\.gz$")) | .browser_download_url' | head -n1)"
  [ -n "${GITLEAKS_URL}" ] && curl -fL "${GITLEAKS_URL}" | tar -xz -C /usr/local/bin gitleaks || true
  curl -fL https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint && chmod +x /usr/local/bin/hadolint || true
fi


SOPS_URL="$(curl -fsSL https://api.github.com/repos/getsops/sops/releases/latest | jq -r ".assets[] | select(.name | test(\"linux\\\\.${ARCH}$\")) | .browser_download_url" | head -n1)"
if [ -n "${SOPS_URL}" ]; then
  curl -fL "${SOPS_URL}" -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops || true
fi


curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin || true


curl -fL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp


OPENVSCODE_VER="openvscode-server-v1.109.5"
VSCODE_ARCH="$( [ "${ARCH}" = "arm64" ] && echo "arm64" || echo "x64" )"
mkdir -p /openhands
curl -fL "https://github.com/gitpod-io/openvscode-server/releases/download/${OPENVSCODE_VER}/${OPENVSCODE_VER}-linux-${VSCODE_ARCH}.tar.gz" | tar -xz -C /openhands
rm -rf /openhands/.openvscode-server
mv "/openhands/${OPENVSCODE_VER}-linux-${VSCODE_ARCH}" /openhands/.openvscode-server
ln -sf /openhands/.openvscode-server/bin/openvscode-server /usr/local/bin/openvscode-server
ln -sf /openhands/.openvscode-server/bin/remote-cli/openvscode-server /usr/local/bin/code


mkdir -p "${PLAYWRIGHT_BROWSERS_PATH}" /opt /root/.cache
npx playwright install --with-deps chromium firefox webkit
chmod -R 755 "${PLAYWRIGHT_BROWSERS_PATH}"
ln -sfn "${PLAYWRIGHT_BROWSERS_PATH}" /opt/playwright-browsers
ln -sfn "${PLAYWRIGHT_BROWSERS_PATH}" /root/.cache/ms-playwright


PW_CHROME="$(find "${PLAYWRIGHT_BROWSERS_PATH}" -maxdepth 3 -name chrome -type f | head -n1 || true)"
if [ -n "${PW_CHROME}" ]; then
  ln -sf "${PW_CHROME}" /usr/local/bin/chromium
  ln -sf "${PW_CHROME}" /usr/bin/chromium
  ln -sf "${PW_CHROME}" /usr/local/bin/google-chrome
fi


if [ "${ARCH}" = "amd64" ]; then
  BLENDER_TARBALL="$(curl -fsSL https://download.blender.org/release/Blender4.5/ 2>/dev/null | grep -oE 'blender-4\.5\.[0-9]+-linux-x64\.tar\.xz' | sort -V | tail -n1 || true)"
  BLENDER_TARBALL="${BLENDER_TARBALL:-blender-4.5.14-linux-x64.tar.xz}"
  rm -rf /opt/blender && mkdir -p /opt/blender
  if curl -fL "https://download.blender.org/release/Blender4.5/${BLENDER_TARBALL}" | tar -xJ -C /opt/blender --strip-components=1; then
    ln -sf /opt/blender/blender /usr/local/bin/blender
    ln -sf /opt/blender/blender /usr/bin/blender
  else
    apt-get install -y blender || true
  fi
else
  apt-get install -y blender || true
fi


if [ -f /etc/ImageMagick-6/policy.xml ]; then
  sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/g' /etc/ImageMagick-6/policy.xml || true
fi


curl -fsSL https://install.duckdb.org | sh
cp -f "$HOME/.duckdb/cli/latest/duckdb" /usr/local/bin/duckdb || true


cat << 'EOF' > /usr/local/bin/start-gui
#!/usr/bin/env bash
export DISPLAY=${DISPLAY:-:99}
export WIDTH=${WIDTH:-1024}
export HEIGHT=${HEIGHT:-768}
if ! pgrep -x "Xvfb" > /dev/null; then
  Xvfb "${DISPLAY}" -screen 0 "${WIDTH}x${HEIGHT}x24" -ac +extension GLX +render -noreset >/dev/null 2>&1 &
  sleep 1
fi
if ! pgrep -x "xfce4-session" > /dev/null; then
  dbus-launch startxfce4 >/dev/null 2>&1 &
fi
if ! pgrep -x "x11vnc" > /dev/null; then
  x11vnc -display "${DISPLAY}" -nopw -forever -shared -bg -rfbport 5900 >/dev/null 2>&1 || true
fi
if ! pgrep -f "websockify.*6080" > /dev/null && [ -d /usr/share/novnc ]; then
  websockify -D --web=/usr/share/novnc/ 6080 localhost:5900 >/dev/null 2>&1 || true
fi
EOF
chmod +x /usr/local/bin/start-gui


/usr/local/bin/uv pip install --system --break-system-packages \
  playwright httpx "httpx[socks]" httpx-aiohttp requests aiohttp websockets wsproto urllib3 \
  beautifulsoup4 lxml html5lib defusedxml html2text PyYAML jsonschema \
  fastapi "uvicorn[standard]" sse-starlette python-multipart python-socketio pydantic orjson \
  pandas numpy scipy scikit-learn scikit-image sympy mpmath statsmodels \
  matplotlib seaborn plotly bokeh kaleido xarray pyarrow datasets tabulate streamlit \
  nltk textblob joblib networkx tqdm python-dateutil pytz \
  duckdb sqlalchemy aiosqlite asyncpg pg8000 psycopg2-binary pymysql redis "fakeredis[lua]" alembic \
  openpyxl xlsxwriter xlrd python-docx python-pptx "reportlab[pycairo]" "markitdown[all]" \
  pypdf PyPDF2 pdfplumber pymupdf pypdfium2 pdf2image img2pdf pdfkit tabula-py pytesseract pylatexenc \
  pillow opencv-python-headless imageio imageio-ffmpeg soundfile librosa pyautogui mss pyperclip \
  jupyter-server jupyterlab notebook jupyter_kernel_gateway ipykernel ipython ipywidgets qtconsole \
  pytest pytest-asyncio pytest-cov pytest-xdist pytest-timeout flake8 \
  openai "anthropic[bedrock,vertex]" litellm google-genai \
  google-auth google-api-python-client google-auth-httplib2 google-auth-oauthlib google-cloud-aiplatform \
  boto3 kubernetes docker modal daytona e2b-code-interpreter mcp fastmcp agent-client-protocol \
  libtmux bashlex pexpect shellingham psutil \
  json-repair python-frontmatter whatthepatch pathspec dirhash binaryornot puremagic \
  pygithub GitPython rapidfuzz termcolor toml types-toml pyjwt "python-jose[cryptography]" joserfc \
  tenacity deprecated deprecation filelock cachetools func-timeout memory-profiler \
  tree-sitter tree-sitter-bash tree-sitter-python tree-sitter-language-pack libcst grep-ast \
  opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp-proto-grpc \
  browser-use browsergym-core gymnasium pyparsing


/usr/local/bin/uv pip install --system --break-system-packages openhands-aci || true
python3 -m playwright install chromium || true


curl -fsSL https://opencode.ai/v2/install | bash
if [ -f "$HOME/.opencode/bin/opencode" ]; then
  ln -sf "$HOME/.opencode/bin/opencode" /usr/local/bin/opencode
  ln -sf "$HOME/.opencode/bin/opencode" /usr/bin/opencode
  [ -f "$HOME/.opencode/bin/opencode2" ] && ln -sf "$HOME/.opencode/bin/opencode2" /usr/local/bin/opencode2 || true
fi
for rc in "$HOME/.bashrc" "/root/.bashrc" "/config/.bashrc"; do
  if [ -f "$rc" ] || [ "$(dirname "$rc")" = "$HOME" ]; then
    touch "$rc"
    if ! grep -q '\.opencode/bin' "$rc" 2>/dev/null; then
      echo 'export PATH="$HOME/.opencode/bin:/root/.opencode/bin:/config/.opencode/bin:$PATH"' >> "$rc"
    fi
  fi
done


rm -rf /tmp/anthropic-skills
git clone --depth 1 https://github.com/anthropics/skills.git /tmp/anthropic-skills && \
  mkdir -p /config/.config/opencode/skills "$HOME/.config/opencode/skills" /usr/local/share/fonts/canvas-design && \
  cp -r /tmp/anthropic-skills/skills/* /config/.config/opencode/skills/ && \
  cp -r /tmp/anthropic-skills/skills/* "$HOME/.config/opencode/skills/" 2>/dev/null || true && \
  cp -f /tmp/anthropic-skills/skills/canvas-design/canvas-fonts/*.ttf /usr/local/share/fonts/canvas-design/ 2>/dev/null || true && \
  fc-cache -f || true
rm -rf /tmp/anthropic-skills


NPM_GLOBAL_ROOT="$(npm root -g 2>/dev/null || echo /usr/local/lib/node_modules)"


cat << EOF > /etc/profile.d/ai-agent-env.sh
export DEBIAN_FRONTEND=noninteractive
export CI=true
export PAGER=cat
export GIT_PAGER=cat
export BAT_PAGER=cat
export GIT_TERMINAL_PROMPT=0
export PIP_DISABLE_PIP_VERSION_CHECK=1
export PYTHONDONTWRITEBYTECODE=1
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export NODE_PATH="${NPM_GLOBAL_ROOT}:/usr/local/lib/node_modules:/usr/lib/node_modules"
export PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
export CHROME_BIN=/usr/bin/chromium
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
export CHROMIUM_FLAGS="--no-sandbox --disable-dev-shm-usage --disable-gpu"
export OPENVSCODE_SERVER_ROOT=/openhands/.openvscode-server
export EDITOR=code
export VISUAL=code
export GIT_EDITOR="code --wait"
export DISPLAY=:99
export DISPLAY_NUM=99
export WIDTH=1024
export HEIGHT=768
export PATH="\$HOME/.opencode/bin:/root/.opencode/bin:/config/.opencode/bin:/usr/local/bin:/opt/rust/cargo/bin:/openhands/.openvscode-server/bin:\$HOME/.local/bin:\$PATH"


if command -v Xvfb >/dev/null 2>&1 && ! pgrep -x "Xvfb" >/dev/null 2>&1; then
  Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset >/dev/null 2>&1 &
fi
EOF


chmod +x /etc/profile.d/ai-agent-env.sh
source /etc/profile.d/ai-agent-env.sh || true


if ! grep -q "ai-agent-env.sh" /etc/bash.bashrc; then
  echo 'source /etc/profile.d/ai-agent-env.sh' >> /etc/bash.bashrc
fi


apt-get clean && rm -rf /var/lib/apt/lists/*
