#!/bin/zsh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Install core packages
print_status "Installing core packages..."
brew install \
    wget \
    jq \
    ripgrep \
    git \
    gh \
    starship \
    zsh \
    zsh-autosuggestions \
    zsh-fast-syntax-highlighting \
    zoxide

# Install window management tools
print_status "Installing window management tools..."
brew install aerospace
brew install sketchybar
brew install borders
brew install --cask raycast

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

# Function to install cask with error handling
install_cask() {
    local cask_name="$1"
    local app_name="$2"
    
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
install_cask "unifi-portal" "UniFi Portal"
install_cask "gimp" "Gimp"
install_cask "upscayl" "Upscayl"

# UniFi Portal already handled in install_cask function above

# Install Mac App Store Apps
print_status "Installing Mac App Store Apps..."
mas install 497799835 #xCode
mas install 1480933944 #Vimari - Vim keybindings for Safari

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

# macOS Settings
print_status "Applying macOS defaults..."

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
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Screenshot settings
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"

# Network
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

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

# Create symlinks for configs
create_symlink "$SCRIPT_DIR/.config/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$SCRIPT_DIR/.config/aerospace" "$HOME/.config/aerospace"
create_symlink "$SCRIPT_DIR/.config/sketchybar" "$HOME/.config/sketchybar"
create_symlink "$SCRIPT_DIR/.config/jankyborders" "$HOME/.config/jankyborders"

# Start services
print_status "Starting services..."

# Enable aerospace to launch at login
brew services start aerospace

# Configure Raycast with our keybindings
print_status "Configuring Raycast with custom shortcuts..."
if [ -f "$SCRIPT_DIR/scripts/configure-raycast.sh" ]; then
    # Only configure if Raycast config doesn't exist or if --force flag is used
    if [ ! -f "$HOME/Library/Application Support/com.raycast.macos/raycast.json" ] || [ "$1" = "--force" ]; then
        bash "$SCRIPT_DIR/scripts/configure-raycast.sh"
    else
        print_status "Raycast already configured, skipping (use --force to reconfigure)"
    fi
else
    print_warning "Raycast configuration script not found"
fi

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

print_status "Installing sketchybar font..."
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf

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
print_warning "Please restart your terminal and log out/in to apply all changes"
print_status "Note: Configure aerospace permissions in System Settings > Privacy & Security > Accessibility"
echo
print_status "For gaming setup with DLSS support:"
echo "  1. Download Game Porting Toolkit 3.0 from Apple Developer"
echo "  2. Run: ~/dotfiles/scripts/setup-gptk.sh"
echo "  3. Enable DLSS in your games and use Metal HUD to verify"
