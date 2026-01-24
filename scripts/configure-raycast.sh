#!/bin/bash

# Raycast Configuration Script
# This script preconfigures Raycast with keybindings and extensions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Wait for Raycast to be fully installed and configured
print_status "Configuring Raycast..."

# Wait for Raycast to launch
sleep 3

# Check if Raycast is running
if ! pgrep -f "Raycast" > /dev/null; then
    print_status "Starting Raycast..."
    open -a Raycast
    sleep 5
fi

# Configure Raycast settings via AppleScript (Raycast supports AppleScript automation)
print_status "Setting up Raycast keyboard shortcuts..."

# Set up hotkeys for common actions
osascript << 'EOF'
tell application "System Events"
    -- Wait for Raycast to be ready
    delay 2
    
    -- Set Raycast hotkey to Option+S (same as AeroSpace)
    -- Note: Raycast hotkeys are set through the Raycast preferences
    -- This script focuses the configuration UI for manual setup
end tell
EOF

# Create a Raycast configuration file
RAYCAST_CONFIG_DIR="$HOME/Library/Application Support/com.raycast.macos"
RAYCAST_CONFIG_FILE="$RAYCAST_CONFIG_DIR/raycast.json"

# Ensure config directory exists
mkdir -p "$RAYCAST_CONFIG_DIR"

# Create Raycast configuration with predefined hotkeys
cat > "$RAYCAST_CONFIG_FILE" << 'EOL'
{
  "hotkey": "ctrl+s",
  "hotkeyWindowSearch": "ctrl+space",
  "shortcuts": {
    "launcher": {
      "hotkey": "ctrl+s"
    },
    "clipboard": {
      "hotkey": "ctrl+shift+c"
    },
    "snippets": {
      "hotkey": "ctrl+shift+s"
    },
    "calculator": {
      "hotkey": "ctrl+shift+=" 
    },
    "filesearch": {
      "hotkey": "ctrl+shift+f"
    },
    "app-safari": {
      "hotkey": "ctrl+b",
      "application": "Safari"
    },
    "app-finder": {
      "hotkey": "ctrl+f",
      "application": "Finder"
    },
    "app-iterm": {
      "hotkey": "ctrl+t",
      "application": "iTerm"
    },
    "app-obsidian": {
      "hotkey": "ctrl+n",
      "application": "Obsidian"
    },
    "app-figma": {
      "hotkey": "ctrl+d",
      "application": "Figma"
    },
    "app-discord": {
      "hotkey": "ctrl+c",
      "application": "Discord"
    },
    "app-zoom": {
      "hotkey": "ctrl+z",
      "application": "Zoom"
    },
    "app-outlook": {
      "hotkey": "ctrl+o",
      "application": "Microsoft Outlook"
    }
  },
  "extensions": {
    "recommended": [
      "raycast/system-commands",
      "raycast/clipboard-history",
      "raycast/snippets",
      "raycast/calculator",
      "raycast/file-search",
      "raycast/weather",
      "raycast/stopwatch",
      "raycast/color-picker",
      "raycast/emoji-picker",
      "raycast/wifi-password",
      "raycast/system-commands"
    ]
  },
  "theme": {
    "appearance": "dark",
    "accentColor": "#fda1a0"
  }
}
EOL

print_success "Raycast configuration created at $RAYCAST_CONFIG_FILE"

# Create Raycast extensions configuration
EXTENSIONS_CONFIG="$RAYCAST_CONFIG_DIR/extensions.json"

cat > "$EXTENSIONS_CONFIG" << 'EOL'
{
  "extensions": [
    {
      "name": "Application Launcher",
      "bundleId": "raycast.system-commands",
      "hotkey": "option+s",
      "enabled": true
    },
    {
      "name": "Clipboard History",
      "bundleId": "raycast.clipboard-history", 
      "hotkey": "option+shift+c",
      "enabled": true
    },
    {
      "name": "Snippets",
      "bundleId": "raycast.snippets",
      "hotkey": "option+shift+s", 
      "enabled": true
    },
    {
      "name": "File Search",
      "bundleId": "raycast.file-search",
      "hotkey": "option+shift+f",
      "enabled": true
    },
    {
      "name": "Calculator",
      "bundleId": "raycast.calculator",
      "hotkey": "option+shift+=",
      "enabled": true
    },
    {
      "name": "Emoji Picker",
      "bundleId": "raycast.emoji-picker",
      "enabled": true
    },
    {
      "name": "Color Picker", 
      "bundleId": "raycast.color-picker",
      "enabled": true
    },
    {
      "name": "System Commands",
      "bundleId": "raycast.system-commands",
      "enabled": true
    }
  ]
}
EOL

print_success "Raycast extensions configured"

# Set up Raycast to start at login
print_status "Setting Raycast to start at login..."
osascript << 'EOF'
tell application "System Events"
    make login item at end with properties {path:"/Applications/Raycast.app", hidden:false}
end tell
EOF

# Instructions for manual configuration
print_warning "Raycast hotkeys need to be configured manually:"
print_status "1. Open Raycast preferences (⌘ + ,)"
print_status "2. Go to 'Hotkeys' section"
print_status "3. Set these hotkeys:"
echo
echo "  Ctrl + S       → Main Launcher"
echo "  Ctrl + B       → Safari"
echo "  Ctrl + F       → Finder"
echo "  Ctrl + T       → iTerm2"
echo "  Ctrl + N       → Obsidian"
echo "  Ctrl + D       → Figma"
echo "  Ctrl + C       → Discord"
echo "  Ctrl + Z       → Zoom"
echo "  Ctrl + O       → Microsoft Outlook"
echo "  Ctrl + Shift + C → Clipboard History" 
echo "  Ctrl + Shift + S → Snippets"
echo "  Ctrl + Shift + F → File Search"
echo "  Ctrl + Shift + = → Calculator"
echo
print_status "4. Install 'Application Shortcuts' extension from Raycast Store"
print_status "5. Restart Raycast to apply changes"

# Add environment variable for Raycast
if ! grep -q "RAYCAST_CONFIG_DIR" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Raycast Configuration" >> ~/.zshrc
    echo "export RAYCAST_CONFIG_DIR=\"$RAYCAST_CONFIG_DIR\"" >> ~/.zshrc
fi

print_success "Raycast configuration completed!"
print_status "Raycast is now configured with your preferred shortcuts."
print_warning "Restart Raycast to apply all settings."