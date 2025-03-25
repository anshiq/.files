#!/bin/bash

# Exit on error
set -e

echo "Starting Ubuntu setup script..."

# Update and upgrade packages
echo "Updating package lists and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y || { echo "Failed to update/upgrade packages"; exit 1; }

# Install essential packages
echo "Installing essential packages..."
sudo apt install nano build-essential tmux unzip git wget npm thunar curl fish software-properties-common -y || { echo "Failed to install essential packages"; exit 1; }

# Install Helix editor
echo "Installing Helix editor..."
if ! command -v hx &> /dev/null; then
    sudo add-apt-repository ppa:maveonair/helix-editor -y
    sudo apt update
    sudo apt install helix -y
else
    echo "Helix editor already installed, skipping..."
fi

# Create local bin directory
echo "Creating local bin directory..."
mkdir -p ~/.local/bin

# golang
# Create .go directory first
mkdir -p ~/.go
wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz 
tar -C ~/.go -xzf go1.24.1.linux-amd64.tar.gz
rm go1.24.1.linux-amd64.tar.gz  # Remove the downloaded tarball

# rust

set +e  # Prevent the script from exiting on errors

echo "Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
if [ $? -ne 0 ]; then
    echo "Failed to install Rust" >&2
    # Continue execution even if Rust installation fails
fi

# Source the cargo environment for different shells
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"  # For sh/bash/zsh/ash/dash/pdksh
else
    echo "Cargo environment file not found" >&2
fi

if [ -f "$HOME/.cargo/env.fish" ]; then
    source "$HOME/.cargo/env.fish"  # For fish shell
else
    echo "Cargo environment file for fish shell not found" >&2
fi

# Symlink rust-analyzer if it exists
which rust-analyzer > /dev/null 2>&1
if [ $? -eq 0 ]; then
    rustup component add rust-analyzer 
    sudo ln -s $HOME/.cargo/bin/rust-analyzer /usr/local/bin/rust-analyzer
    if [ $? -ne 0 ]; then
        echo "Failed to symlink rust-analyzer" >&2
        # Continue execution even if symlink fails
    fi
else
    echo "rust-analyzer not found in PATH" >&2
fi

echo "Installation process completed."

set -e  # Re-enable exit on error if needed for the rest of the script
# Set up NPM

echo "Setting up NPM..."
sudo npm i -g n || { echo "Failed to install n"; exit 1; }
mkdir -p "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"

# Python setup - Using a safer approach with virtual environments
echo "Setting up Python environment..."
if [ -f /usr/lib/python3.11/EXTERNALLY-MANAGED ]; then
    echo "WARNING: You're about to remove EXTERNALLY-MANAGED which may affect system package management."
    echo "A safer alternative is to use virtual environments for Python projects."
    echo "Proceeding in 5 seconds... Press Ctrl+C to cancel."
    sleep 5
    sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
fi

if [ -f /usr/lib/python3.12/EXTERNALLY-MANAGED ]; then
    sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED
fi

export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH/go/bin
export EDITOR=hx
export PAGER=less
export LSCOLORS=gxfxcxdxbxegedabagacad
export PATH=$PATH:$HOME/.npm-packages/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.tmuxifier/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/jdtls/bin

# Tmux and Tmuxifier setup
echo "Setting up tmux and tmuxifier..."
if [ ! -d ~/.tmuxifier ]; then
    git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
else
    echo "Tmuxifier already installed, skipping..."
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "Tmux Plugin Manager already installed, skipping..."
fi

# Backup existing tmux.conf
if [ -f ~/.tmux.conf ]; then
    cp ~/.tmux.conf ~/.tmux.conf.bak
    echo "Backed up existing .tmux.conf to .tmux.conf.bak"
fi

# Create tmux.conf
echo "Creating tmux configuration..."
cat > ~/.tmux.conf << 'EOF'
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

set -g mouse on
set -g window-status-style bg=yellow
set -g status-bg cyan
set -g window-status-current-style bg=red,fg=white
set-option -ga terminal-overrides ",xterm-256color:Tc"
set -g @resurrect-capture-pane-contents 'on' # allow tmux-ressurect to capture pane contents
set -g @continuum-restore 'on' # enable tmux-continuum functionality

run '~/.tmux/plugins/tpm/tpm'
EOF

# Fish shell setup
echo "Setting up fish shell..."
mkdir -p ~/.config/fish

# Backup existing fish config
if [ -f ~/.config/fish/config.fish ]; then
    cp ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
    echo "Backed up existing fish config to config.fish.bak"
fi

# Create fish config
echo "Creating fish configuration..."
cat > ~/.config/fish/config.fish << 'EOF'
source "$HOME/.cargo/env.fish"
# NPM packages
fish_add_path ~/.npm-packages/bin

# Local bin directory
fish_add_path $HOME/.local/bin
# java jdtls path 
fish_add_path $HOME/.local/jdtls/bin

# Go
set -gx GOPATH $HOME/.go
fish_add_path $GOPATH/bin
fish_add_path $GOPATH/go/bin


# Set the default editor to helix
set -gx EDITOR hx

# Set the default pager
set -gx PAGER less

# Configure colors for ls command
set -gx LSCOLORS gxfxcxdxbxegedabagacad

# Tmuxifier
fish_add_path $HOME/.tmuxifier/bin

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Functions
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Greeting
function fish_greeting
    echo ""
end

# Enable Vi mode (optional, remove if you prefer Emacs keybindings)
fish_vi_key_bindings

# Source any local configurations (create this file for machine-specific settings)
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# Uncomment to automatically change to a specific directory on startup
# if not set -q VSCODE_SHELL
#     cd /mnt/c/Users/anshi/OneDrive/Desktop
# end
EOF

# Helix editor setup
echo "Setting up Helix editor..."
mkdir -p ~/.config/helix

# Create Helix languages.toml
echo "Creating Helix language configuration..."
cat > ~/.config/helix/languages.toml << 'EOF'
[[language]]
name = "html"
formatter = { command = 'prettier', args = ["--parser", "html"] }

[[language]]
name = "json"
formatter = { command = 'prettier', args = ["--parser", "json"] }

[[language]]
name = "css"
formatter = { command = 'prettier', args = ["--parser", "css"] }

[[language]]
name = "javascript"
formatter = { command = 'prettier', args = ["--parser", "typescript"] }
auto-format = true

[[language]]
name = "typescript"
auto-format = true
formatter = { command = 'prettier', args = ["--parser", "typescript"] }
# config = { format = { "semicolons" = "insert", "insertSpaceBeforeFunctionParenthesis" = true }}

[[language]]
name = "tsx"
formatter = { command = 'prettier', args = ["--parser", "typescript"] }
auto-format = true

[[language]]
name = "jsx"
formatter = { command = 'prettier', args = ["--parser", "typescript"] }
auto-format = true

# [language.config.typescript]
# tsdk = "/home/anshik/.npm-packages/lib/node_modules/typescript/lib"   #this might be different for you, I found it with locate command

[[language]]
name = "go"
roots = ["go.work", "go.mod"]
auto-format = true
comment-token = "//"
language-servers = [ "gopls"]

[language-server.gopls]
command = "gopls"
config = { "gofumpt" = true, "local" = "goimports", "semanticTokens" = true, "staticcheck" = true, "verboseOutput" = true, "analyses" = { "fieldalignment" = true, "nilness" = true, unusedparams = true, unusedwrite = true, useany = true }, usePlaceholders = true, completeUnimported = true, hints = { "assignVariableType" = true, "compositeLiteralFields" = true, "compositeLiteralTypes" = true, "constantValues" = true, "functionTypeParameters" = true, "parameterNames" = true, "rangeVariableTypes" = true } }

[[language]]
name = "cpp"
scope = "source.cpp"
injection-regex = "cpp"
file-types = ["cc", "hh", "c++", "cpp", "hpp", "h", "ipp", "tpp", "cxx", "hxx", "ixx", "txx", "ino", "C", "H", "cu", "cuh", "cppm", "h++", "ii", "inl", { glob = ".hpp.in" }, { glob = ".h.in" }]
comment-token = "//"
block-comment-tokens = { start = "/*", end = "*/" }
language-servers = [ "clangd" ]
indent = { tab-width = 4, unit = "    " }

[[language]]
name = "yaml"
indent = { tab-width = 4, unit = "    " }

[[language]]
name = "rust"
[language-server.rust-analyzer.config.check]
command = "clippy"

[language.debugger]
name = "lldb-19"
transport = "stdio"
command = "lldb-19"

[[language.debugger.templates]]
name = "binary"
request = "launch"
completion = [ { name = "binary", completion = "filename" } ]
args = { program = "{0}", initCommands = [ "command script import /usr/local/etc/lldb_vscode_rustc_primer.py" ] }


# [language-server]
# jdtls = { command = "jdtls" }
# language-server = { command = "jdtls", args = [ "-data", "/home/<USER>/.cache/jdtls/workspace" ]}

[[language]]
name = "java"
scope = "source.java"
injection-regex = "java"
file-types = ["java"]
roots = ["pom.xml", "build.gradle", ]
indent = { tab-width = 4, unit = "    " }
language-servers = [ "jdtls" ]
EOF

# Create Helix config.toml
echo "Creating Helix editor configuration..."
cat > ~/.config/helix/config.toml << 'EOF'
theme = "onedark"

[editor]
line-number = "relative"
true-color = true
mouse = true
bufferline = "always"
auto-format = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.file-picker]
hidden = false

[editor.lsp]
display-messages = true

[keys.select]
"C-[" = ["normal_mode", "keep_primary_selection", "collapse_selection"]

[keys.normal]
a = "move_char_left"
C-p = ":clipboard-paste-replace"
C-y = ":clipboard-yank"
EOF

# Install language servers
echo "Installing language servers..."
npm i -g yaml-language-server bash-language-server typescript typescript-language-server vscode-langservers-extracted vscode-languageserver-types prettier || { echo "Failed to install npm language servers"; exit 1; }

# Install additional packages
echo "Installing additional development tools..."
sudo apt install openjdk-21-jdk clangd lldb protobuf-compiler protoc-gen-go protoc-gen-go-grpc -y || { echo "Failed to install additional development tools"; exit 1; }

# Install jdtls
echo "Installing ldtls java language server ..."
wget https://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz
mkdir ~/.local/jdtls
tar -xvf jdt-language-server-latest.tar.gz -C ~/.local/jdtls/
echo "Done ldtls java language server ..."
# Install marksman for markdown
echo "Installing marksman for markdown..."
if [ ! -f ~/.local/bin/marksman ]; then
    wget -O marksman-linux-x64 https://github.com/artempyanykh/marksman/releases/download/2024-12-18/marksman-linux-x64 || { echo "Failed to download marksman"; exit 1; }
    chmod +x marksman-linux-x64
    mv marksman-linux-x64 ~/.local/bin/marksman
else
    echo "Marksman already installed, skipping..."
fi

# Install buf language server
echo "Installing gopls, dlv and  buf language server..."
if command -v go &> /dev/null; then
    go install github.com/bufbuild/buf-language-server/cmd/bufls@latest || { echo "Failed to install buf language server"; exit 1; }
    go install golang.org/x/tools/gopls@latest  || { echo "Failed to install gopls language server"; exit 1; }
    go install github.com/go-delve/delve/cmd/dlv@latest  || { echo "Failed to install go dlv language server debuger"; exit 1; }
else
    echo "Go is not installed, skipping buf language server installation"
fi

# Create personal utility - gfile
echo "Creating personal utility - gfile..."
cat > ~/.local/bin/gfile << 'EOF'
#!/bin/bash

# Loop through the command line arguments
for arg in "$@"
do
    # Get the directory and file name from the argument
    dir=$(dirname "$arg")
    file=$(basename "$arg")

    # Create the directory (and its parent directories) if it doesn't exist
    mkdir -p "$dir"

    # Create the file in the directory
    touch "$dir/$file"
done
EOF

# Make gfile executable
chmod +x ~/.local/bin/gfile

# Set fish as default shell
echo "Setting fish as default shell..."
if [ "$SHELL" != "$(which fish)" ]; then
    chsh -s $(which fish)
    echo "Changed default shell to fish. You may need to log out and back in for this to take effect."
else
    echo "Fish is already the default shell."
fi

echo "Setup completed successfully!"
echo "Please log out and log back in for all changes to take effect."
