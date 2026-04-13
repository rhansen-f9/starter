# 1. Base Image
FROM zauberzeug/nicegui:latest

USER root

# 2. Install System Essentials, Mosh, and Neovim
RUN apt-get update && apt-get install -y \
    git mosh curl ripgrep fd-find build-essential unzip \
    && rm -rf /var/lib/apt/lists/*

# 3. Install 'uv'
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 4. Install Latest Stable Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# 5. Setup LazyVim
RUN mkdir -p /usr/share/fonts/truetype/nerd-fonts \
    && curl -fLo "/usr/share/fonts/truetype/nerd-fonts/SymbolsNerdFont.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf \
    && git clone https://github.com/LazyVim/starter ~/.config/nvim \
    && nvim --headless "+Lazy! sync" +qa
