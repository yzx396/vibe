#!/bin/bash
set -e

# vibe installation script
# This script installs the vibe CLI tool and sets up Claude Code integration

REPO_URL="https://github.com/Blurjp/vibe.git"
INSTALL_DIR="${VIBE_INSTALL_DIR:-$HOME/.vibe}"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

echo "[vibe] Installing vibe..."

# Detect if we're already in the repo
if [ -d "tools/vibe" ] && [ -f "tools/vibe/vibe" ]; then
    echo "[vibe] Already in vibe repo, skipping clone..."
    VIBE_DIR="$(pwd)"
else
    # Create install directory
    mkdir -p "$INSTALL_DIR"

    # Clone or update the repo
    if [ -d "$INSTALL_DIR/vibe" ]; then
        echo "[vibe] Updating existing installation..."
        cd "$INSTALL_DIR/vibe"
        git pull
    else
        echo "[vibe] Cloning repo to $INSTALL_DIR/vibe..."
        git clone "$REPO_URL" "$INSTALL_DIR/vibe"
        cd "$INSTALL_DIR/vibe"
    fi
    VIBE_DIR="$INSTALL_DIR/vibe"
fi

# NOTE: vibe init should be run in YOUR project folder, not here
# This only sets up the vibe tool itself
echo "[vibe] Note: Run 'vibe init' in your project folder to set up .vibedbg/"

# Set up Claude Code integration
echo "[vibe] Setting up Claude Code integration..."
mkdir -p "$CLAUDE_COMMANDS_DIR"
cp tools/vibe/claude-commands/*.md "$CLAUDE_COMMANDS_DIR/"

# Make vibe executable
chmod +x tools/vibe/vibe

# Add to PATH if not already there
SHELL_CONFIG="$HOME/.zshrc"
if [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

# Check if vibe alias already exists
if ! grep -q "alias vibe=" "$SHELL_CONFIG" 2>/dev/null; then
    echo "[vibe] Adding alias to $SHELL_CONFIG..."
    echo "" >> "$SHELL_CONFIG"
    echo "# vibe: screen region debugging tool" >> "$SHELL_CONFIG"
    echo "alias vibe=\"$VIBE_DIR/tools/vibe/vibe\"" >> "$SHELL_CONFIG"
    echo "[vibe] Added 'vibe' alias to $SHELL_CONFIG"
    echo "[vibe] Run 'source $SHELL_CONFIG' or restart your shell to use the alias."
else
    echo "[vibe] 'vibe' alias already exists in $SHELL_CONFIG"
fi

# Create symlink for global access (optional)
if [ ! -L "$INSTALL_DIR/vibe" ] && [ -w "/usr/local/bin" ] 2>/dev/null; then
    echo "[vibe] Creating symlink in /usr/local/bin (requires sudo)..."
    sudo ln -sf "$VIBE_DIR/tools/vibe/vibe" "/usr/local/bin/vibe" 2>/dev/null || echo "[vibe] Could not create symlink (may need sudo)"
fi

echo ""
echo "[vibe] Installation complete!"
echo ""
echo "Installed to: $VIBE_DIR"
echo ""
echo "Usage in any project folder:"
echo "  cd /path/to/your/project"
echo "  vibe init                    # Initialize .vibedbg/ in current project"
echo "  vibe select [--note \"...\"]   # Capture screen region"
echo "  vibe ask \"...\"               # Ask Claude to fix"
echo ""
echo "Or use within Claude Code CLI (from any project):"
echo "  /vibe-select                  # Capture screen region"
echo "  /vibe-ask                     # Analyze and fix"
echo ""
echo "Next steps:"
echo "  1. Run: source $SHELL_CONFIG"
echo "  2. cd to your project folder"
echo "  3. Run: vibe init"
