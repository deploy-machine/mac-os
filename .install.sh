#!/bin/zsh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CWD=$(pwd)

# Function to install Mac App Store apps with error handling
install_mas_app() {
    local app_id="$1"
    local app_name="$2"
    
    # Check if signed in to App Store
    if ! mas account > /dev/null 2>&1; then
        print_warning "Not signed in to App Store. Please sign in and try again."
        print_status "You can sign in with: mas signin <apple_id>"
        return 1
    fi
    
    # Check if app is already installed
    if mas list | grep -q "$app_id"; then
        print_success "$app_name already installed, skipping..."
        return 0
    fi
    
    # Check if app is available in current region
    print_status "Checking availability of $app_name..."
    if ! mas info "$app_id" > /dev/null 2>&1; then
        print_warning "$app_name (ID: $app_id) not available in your region's App Store"
        print_status "Please install manually from the App Store"
        return 0
    fi
    
    print_status "Installing $app_name..."
    if mas install "$app_id"; then
        print_success "$app_name installed successfully"
    else
        print_error "Failed to install $app_name"
        print_status "Please install manually from the App Store"
        return 1
    fi
}

# Function to install cask with error handling
install_cask() {
    local cask_name="$1"
    local app_name="$2"
    
    # Check if this is a font cask and if the font already exists
    if [[ "$cask_name" =~ ^font- ]]; then
        font_name=$(echo "$cask_name" | sed 's/^font-//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
        # Try to find the font file in common formats
        for font_ext in ttf otf ttc; do
            font_file=$(find "$HOME/Library/Fonts" -name "*${font_name}*.${font_ext}" 2>/dev/null | head -n 1)
            if [ -n "$font_file" ]; then
                print_success "$app_name already installed, skipping..."
                return 0
            fi
        done
    fi
    
    # Special case mapping for apps that install with different names
    case "$cask_name" in
        "iterm2")
            install_path="/Applications/iTerm.app"
            ;;
        "microsoft-office")
            # Check for any Office app
            if [ -d "/Applications/Microsoft Word.app" ] || [ -d "/Applications/Microsoft Excel.app" ] || [ -d "/Applications/Microsoft PowerPoint.app" ]; then
                print_success "Microsoft Office already installed, skipping..."
                return 0
            fi
            ;;
        "league-of-legends")
            install_path="/Applications/League of Legends.app"
            ;;
        "dbeaver-community")
            install_path="/Applications/DBeaver.app"
            ;;
        "bitwarden")
            install_path="/Applications/Bitwarden.app"
            ;;
        "android-studio")
            install_path="/Applications/Android Studio.app"
            ;;
        "microsoft-outlook")
            install_path="/Applications/Microsoft Outlook.app"
            ;;
        "google-chrome")
            install_path="/Applications/Google Chrome.app"
            ;;
        "visual-studio-code")
            install_path="/Applications/Visual Studio Code.app"
            ;;
        "font-sketchybar-app-font")
            # Check if font already exists in Library/Fonts
            if [ -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
                print_success "sketchybar-app-font already installed, skipping..."
                return 0
            fi
            install_path="/Applications/${app_name}.app"
            ;;
        *)
            install_path="/Applications/${app_name}.app"
            ;;
    esac
    
    if [ -d "$install_path" ]; then
        print_success "$app_name already installed, skipping..."
        return 0
    fi
    
    print_status "Installing $app_name..."
    if brew install --cask "$cask_name"; then
        print_success "$app_name installed successfully"
    else
        print_error "Failed to install $app_name"
        return 1
    fi
}

# Function to print colored output
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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_status "Starting macOS dotfiles installation..."

# Install xCode CLI tools
if ! xcode-select -p &> /dev/null; then
    print_status "Installing Xcode CLI tools..."
    xcode-select --install
    print_warning "Please accept the Xcode CLI tools prompt and continue"
    read -p "Press Enter to continue after installation..."
else
    print_success "Xcode CLI tools already installed"
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_success "Homebrew already installed"
fi

brew analytics off

# Add taps
print_status "Adding Homebrew taps..."
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae
brew tap nikitabobko/tap
brew tap joncrangle/tap


# Install core packages
print_status "Installing core packages..."
brew install \
    switchaudio-osx \
    media-control \
    imagemagick \
    wget \
    jq \
    ripgrep \
    git \
    gh \
    lsd \
    bat \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zoxide

# Install window management tools
print_status "Installing window management tools..."
brew install nikitabobko/tap/aerospace
brew install borders
install_cask "raycast" "Raycast"

# Sketchybar
brew install lua
brew install switchaudio-osx
brew install nowplaying-cli

brew install sketchybar

# Fonts
install_cask "sf-symbols" "font-sf-symbols"
install_cask "font-sf-mono" "font-sf-mono"
install_cask "font-sf-pro" "font-sf-pro"

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# SbarLua
if [ -d "/tmp/sbarlua" ]; then
    print_status "SbarLua directory already exists, removing and re-cloning..."
    rm -rf /tmp/sbarlua
fi
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

if [ -d "/tmp/dotfiles" ]; then
  rm -rf /tmp/dotfiles
fi
git clone https://github.com/FelixKratz/dotfiles.git /tmp/dotfiles
rm -rf $HOME/.config/sketchybar
mv /tmp/dotfiles/.config/sketchybar $HOME/.config/sketchybar
rm -rf /tmp/dotfiles
brew services restart sketchybar

# Install development tools
print_status "Installing development tools..."
brew install \
    neovim \
    helix \
    lazygit \
    btop \
    mise

# Install useful apps
print_status "Installing applications..."


# Install each app with error handling
install_cask "iterm2" "iTerm2"
install_cask "discord" "Discord"
install_cask "android-studio" "Android Studio"
install_cask "microsoft-office" "Microsoft Office"
install_cask "obsidian" "Obsidian"
install_cask "figma" "Figma"
install_cask "bitwarden" "Bitwarden"
install_cask "whatsapp" "WhatsApp"
install_cask "dbeaver-community" "DBeaver Community"
install_cask "docker" "Docker Desktop"
install_cask "crossover" "CrossOver"
install_cask "league-of-legends" "League of Legends"
install_cask "onedrive" "OneDrive"
install_cask "zoom" "Zoom"
# Remove conflicting cask if present
print_status "Checking for conflicting unified-remote cask..."
if brew list --cask | grep -q "unified-remote"; then
    print_status "Removing conflicting unified-remote cask..."
    brew uninstall --cask unified-remote
fi


install_cask "gimp" "Gimp"
install_cask "upscayl" "Upscayl"

# Install Mac App Store Apps
print_status "Installing Mac App Store Apps..."

# Check if mas is installed, install if not
if ! command -v mas &> /dev/null; then
    print_status "Installing mas (Mac App Store command line tool)..."
    brew install mas
fi

# install_mas_app "497799835" "Xcode"
# install_mas_app "1480933944" "Vimari"
# install_mas_app "1057750338" "UniFi"
# Note: mas installs commented out due to outdated app store IDs
# See: https://github.com/mas-cli/mas/issues/1052

# Install Xcode Command Line Tools (already done at start)
if ! xcode-select -p &> /dev/null; then
    print_status "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    print_success "Xcode Command Line Tools already installed"
fi

# Install fonts
print_status "Installing fonts..."
brew install --cask \
    font-jetbrains-mono-nerd-font \
    font-sf-mono \
    font-hack-nerd-font

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_success "Oh My Zsh already installed"
fi

# Setup zsh-syntax-highlighting plugin for Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    print_status "Linking zsh-syntax-highlighting to Oh My Zsh plugins..."
    ln -sf "/opt/homebrew/share/zsh-syntax-highlighting" "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
else
    print_success "zsh-syntax-highlighting already linked"
fi

# Setup spaceship prompt
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt" ]; then
    print_status "Installing Spaceship prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1
    ln -sf "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
else
    print_success "Spaceship prompt already installed"
fi

# macOS Settings
print_status "Applying macOS defaults..."

# === SYSTEM KEYBINDING NOTES ===
print_status "Note about system keybindings..."
print_warning "If you experience conflicts, manually disable in System Settings:"
echo "  • System Settings > Keyboard > Keyboard Shortcuts"
echo "  • Disable: Spotlight (Cmd+Space), Mission Control (Cmd+F/B/etc.)"
echo "  • Keep: Ctrl+F for system search"
echo "  • Our shortcuts will work once AeroSpace has focus"

# Note: System keybinding cleanup disabled due to defaults command limitations
# Manual cleanup can be done in System Settings if needed

# Dock and menu bar
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Keyboard and input
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder status bar (show file path and disk info)
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowPathbarInStatusBars -bool true
defaults write com.apple.finder ShowWindowShadow -bool true
defaults write com.apple.finder SidebarWidth -integer 240

# Safari
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Screenshot settings
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"

# Network
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable desktop icons and prevent showing desktop when clicking background
defaults write com.apple.finder CreateDesktop -bool false
defaults write com.apple.finder ShowDesktop -bool false
defaults write com.apple.finder QuitMenuItem -bool true

# Setup dotfiles symlinks
print_status "Setting up configuration files..."

# Create config directory if it doesn't exist
mkdir -p ~/.config

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        print_success "Symlink already exists: $target"
    elif [ -e "$target" ]; then
        print_warning "File exists, backing up: $target"
        mv "$target" "$target.backup"
    fi
    
    if [ ! -e "$target" ]; then
        ln -s "$source" "$target"
        print_success "Created symlink: $target"
    fi
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlinks for configurations
print_status "Setting up configuration files..."

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    print_status "Backing up existing .zshrc..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

print_status "Copying zsh configuration..."
if [ -f "$SCRIPT_DIR/.config/zsh/.zshrc" ]; then
    cp "$SCRIPT_DIR/.config/zsh/.zshrc" "$HOME/.zshrc" || print_warning "Failed to copy .zshrc, continuing..."
fi

print_status "Copying other configuration files..."
cp -Rf "$SCRIPT_DIR/.config/"* "$HOME/.config/" || print_warning "Some config files may not have copied properly"

# Start services
print_status "Starting services..."

# Enable aerospace to launch at login
if command -v aerospace &> /dev/null; then
    # Aerospace uses its own launch mechanism, not brew services
    print_status "Note: Aerospace manages its own launch at login startup"
else
    print_warning "Aerospace not found, skipping service start"
fi

# Start SketchyBar service
if command -v sketchybar &> /dev/null; then
    print_status "Starting SketchyBar service..."
    brew services start sketchybar
else
    print_warning "SketchyBar not found, skipping service start"
fi

# Configure JankyBorders to start at login via Aerospace
if command -v borders &> /dev/null; then
    print_status "Configuring JankyBorders to start with Aerospace..."
    # JankyBorders will be started via aerospace.toml exec section
else
    print_warning "JankyBorders not found, skipping service start"
fi

# Raycast Manual Configuration Required
print_status "Raycast requires manual hotkey configuration..."
echo
print_warning "IMPORTANT: Raycast hotkeys must be set up manually:"
echo
echo "  Open Raycast → Preferences (⌘ + ,) → Hotkeys"
echo
echo "  CTRL + LETTER WORKSPACES:"
echo "    Ctrl + F → Finder (Workspace 1)"
echo "    Ctrl + B → Safari (Workspace 2)"
echo "    Ctrl + N → Obsidian (Workspace 3)"
echo "    Ctrl + T → iTerm2 (Workspace 4)"
echo "    Ctrl + C → Discord (Workspace 5)"
echo "    Ctrl + Z → Zoom (Workspace 6)"
echo "    Ctrl + O → Outlook (Workspace 7)"
echo "    Ctrl + D → Figma (Workspace 8)"
echo
echo "  CTRL + SHIFT + LETTER APP LAUNCHING:"
echo "    Ctrl + Shift + B → Safari"
echo "    Ctrl + Shift + F → Finder"
echo "    Ctrl + Shift + T → iTerm2"
echo "    Ctrl + Shift + N → Obsidian"
echo "    Ctrl + Shift + D → Figma"
echo "    Ctrl + Shift + C → Discord"
echo "    Ctrl + Shift + Z → Zoom"
echo "    Ctrl + Shift + O → Outlook"
echo
echo "  UTILITIES:"
echo "    Ctrl + S → Raycast Launcher"
echo "    Ctrl + F → System Search (when AeroSpace not focused)"
echo
print_status "Install 'Application Shortcuts' extension from Raycast Store for app-specific hotkeys"

# Note: sketchybar and jankyborders typically run via aerospace or manual launch

# Install MilkOutside theme
print_status "Installing MilkOutside theme..."
if [ ! -d "$HOME/.local/share/milkoutside.nvim" ]; then
    git clone https://github.com/color-schemes/milkoutside.nvim ~/.local/share/milkoutside.nvim
else
    print_success "MilkOutside already cloned"
fi

# Setup LazyVim
print_status "Setting up LazyVim..."
if [ -d "$HOME/.config/nvim" ]; then
    print_warning "Backing up existing nvim config..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Clone LazyVim starter
print_status "Setting up LazyVim..."
if [ -d "$HOME/.config/nvim" ]; then
    print_warning "Existing Neovim config found, backing up..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi
git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"

# Copy our custom configuration
print_status "Applying custom LazyVim configuration..."
cp -r "$SCRIPT_DIR/.config/nvim/"* "$HOME/.config/nvim/"

# Install theme extras
cd ~/.local/share/milkoutside.nvim
./extras/install.sh --all

# Setup mise
print_status "Setting up mise..."
if command -v mise &> /dev/null; then
    # Only add to .zshrc if not already there
    if ! grep -q "mise activate" ~/.zshrc; then
        mise activate zsh >> ~/.zshrc
        print_success "Added mise activation to .zshrc"
    else
        print_status "mise already configured in .zshrc"
    fi
    
    print_status "Installing common tools with mise..."
    mise install node@lts python@latest rust@latest go@latest
    mise use -g node@lts python@latest rust@latest go@latest
    
    # Install development tools for Neovim
    print_status "Installing Neovim dependencies..."
    mise install -f node@lts python@latest
else
    print_error "mise not found - please run the script again"
fi

# Reload configurations
print_status "Reloading configurations..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

print_success "Installation completed!"
print_warning "Please restart your computer to apply system keybinding changes"
print_status "Note: Configure aerospace permissions in System Settings > Privacy & Security > Accessibility"
echo
print_status "UPDATED KEYBINDING SYSTEM:"
echo "  • Ctrl + Letter: Switch to named workspace"
echo "    F=Finder, B=Browser, T=Terminal, C=Communication, Z=Meetings"
echo "    O=Mail, D=Design, N=Notes"
echo "  • Ctrl + Shift + Letter: Launch apps via Raycast"
echo "  • Ctrl + F: System-wide search (Spotlight/Find)"
echo "  • Apps auto-start on correct workspaces after login"
echo
print_status "MULTI-MONITOR AUTO-START SETUP:"
echo "  • Workspace 1 (Internal): Finder"
echo "  • Workspace 2 (External 1): Safari"
echo "  • Workspace 3 (External 2): Obsidian"
echo "  • Workspace 4 (External 2): iTerm2"
echo "  • Workspace 5 (External 3): Discord"
echo "  • Workspace 6 (External 3): Zoom"
echo "  • Workspace 7 (External 3): Outlook"
echo "  • Workspace 8 (External 3): Figma"
echo "  • Workspace 9 (External 1): Available"
echo "  • Workspace 10 (Internal): Available"
echo
print_status "For gaming setup with DLSS support:"
echo "  1. Download Game Porting Toolkit 3.0 from Apple Developer"
echo "  2. Run: ~/dotfiles/scripts/setup-gptk.sh"
echo "  3. Enable DLSS in your games and use Metal HUD to verify"
