# macOS Dotfiles

A clean macOS setup with modern window management using AeroSpace, SketchyBar, and Raycast.

## 🚀 Features

- **Window Management**: AeroSpace for tiling window management
- **Status Bar**: SketchyBar with customizable widgets
- **Window Borders**: JankyBorders for beautiful window borders  
- **Launcher**: Raycast for powerful app launching
- **Terminal**: iTerm2 with Zsh + Starship
- **Development**: LazyVim (Neovim), Git, Node.js, Python, Rust, Go preconfigured
- **Communication**: Discord, WhatsApp, Zoom for messaging and meetings
- **Mobile Dev**: Android Studio for mobile development
- **Office**: Microsoft Office 365 suite, OneDrive for cloud storage
- **Apple Dev**: Xcode Command Line Tools for Apple development
- **Browsers**: Safari (native browser) for web browsing
- **Security**: Bitwarden for password management
- **Database**: DBeaver Community for database management
- **Productivity**: Obsidian for note-taking, Figma for design work
- **Gaming**: League of Legends, CrossOver with Game Porting Toolkit 3.0
- **Cross-platform**: Crossover for Windows app compatibility  
- **DevOps**: Docker Desktop for container development

### Game Porting Toolkit 3.0 Setup
- **Script**: `scripts/setup-gptk.sh` 
- **Features**: 
  - Automated Game Porting Toolkit 3.0 installation with DLSS support
  - Updates CrossOver bottles with MetalFX/DLSS capabilities
  - Automatic DLL file preparation and configuration
  - Metal Performance HUD setup for testing
- **Usage**: Run after downloading GPTK 3.0 from Apple Developer portal

## 📦 Installation

1. Clone this repository:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

2. Make the install script executable:
```bash
chmod +x .install.sh
```

3. Run the installer:
```bash
./.install.sh
```

## ⚙️ Configuration

### AeroSpace (Window Manager) - Omarchy-inspired
- **Config**: `~/.config/aerospace/aerospace.toml`
- **App Launching**: **Option (Alt) + Letter** shortcuts
  - **`Option + B`** → Safari (Browser)
  - **`Option + F`** → Finder
  - **`Option + T`** → iTerm2 (Terminal)  
  - **`Option + N`** → Obsidian (Notes)
  - **`Option + D`** → Figma (Design)
  - **`Option + C`** → Discord (Chat)
  - **`Option + Z`** → Zoom (Meetings)
  - **`Option + M`** → Outlook (Mail)
  - **`Option + S`** → Raycast (Launcher)
  - **`Option + Q`** → Quit current app
  - **`Option + Enter`** → Open terminal

- **Window Management**: **Super (Cmd)** key (like Omarchy's Super key)
  - **`Super + H/J/K/L`**: Focus window left/down/up/right
  - **`Super + Shift + H/J/K/L`**: Move window left/down/up/right  
  - **`Super + 1-9/0`**: Switch to workspace 1-10
  - **`Super + Shift + 1-9/0`**: Move window to workspace and follow
  - **`Super + Tab`**: Switch to previous workspace
  - **`Super + W`**: Close current window
  - **`Super + F`**: Toggle fullscreen
  - **`Super + Space`**: Open Raycast launcher
  - **`Super + -/+`**: Resize windows
  - **`Alt + S/D/E/W`**: Change layouts (vertical/horizontal/tall)
  
**Automatic Workspace Assignment**:
  - **Workspace 1**: Finder
  - **Workspace 2**: Safari (Browser)
  - **Workspace 3**: Editors (Neovim)
  - **Workspace 4**: Terminal (iTerm2)
  - **Workspace 5**: Communication (Discord)
  - **Workspace 6**: Meetings (Zoom)
  - **Workspace 7**: Email (Outlook)
  - **Workspace 8**: Productivity (Obsidian)
  - **Workspace 9**: Design (Figma)
  - **Workspace 10**: System apps

### Raycast (App Launcher)
- **Config**: `scripts/configure-raycast.sh` 
- **Primary Hotkey**: **Option + S** (matches AeroSpace)
- **Additional Shortcuts**:
  - **Option + Shift + C** → Clipboard History
  - **Option + Shift + S** → Snippets
  - **Option + Shift + F** → File Search  
  - **Option + Shift + =** → Calculator
  - **⌘ + Space** → Alternative launcher
- **Features**: Auto-start at login, pre-configured extensions, MilkOutside theme colors

### Finder
- **Status Bar**: Shows current file path and disk space information
- **Path Bar**: Displays full directory path at bottom of window
- **View Settings**: Hidden files shown, desktop cleanup, column view by default

### SketchyBar (Status Bar)
- **Config**: `~/.config/sketchybar/sketchybarrc`
- **Plugins**: `~/.config/sketchybar/plugins/`
- **Widgets**: Clock, WiFi, Battery, Volume, Workspaces

### JankyBorders (Window Borders)
- **Config**: `~/.config/jankyborders/config`
- **Style**: Rounded corners with Catppuccin colors

### Raycast (Launcher)
- Install from App Store or via the script
- Configure hotkey in System Settings
- Set up extensions and themes as needed

## 🎨 Theme

Uses MilkOutside color scheme throughout:
- **Cosmic dark theme** with space-inspired colors
- Automatically installs themes for: iTerm2, Fish, Btop, Tmux, Lazygit, FZF
- Neovim configured with MilkOutside theme and essential plugins
- Catppuccin-style colors: Blues, Pinks, Greens in cosmic palette

## 📁 Structure

```
dotfiles/
├── .install.sh              # Main installation script
└── .config/
    ├── aerospace/
    │   └── aerospace.toml    # Window manager config
    ├── sketchybar/
    │   ├── sketchybarrc      # Status bar config
    │   └── plugins/          # Custom plugins
    ├── jankyborders/
    │   └── config            # Window borders config
    ├── nvim/
    │   └── lua/              # LazyVim configuration with MilkOutside theme
    ├── zsh/
    │   └── .zshrc            # Shell configuration
    └── starship.toml         # Prompt configuration
```

## 🔧 Permissions

After installation, grant these permissions in **System Settings > Privacy & Security**:

1. **Accessibility** (required):
   - AeroSpace
   - Raycast

2. **Screen Recording** (optional):
   - SketchyBar (for certain features)

## 🔄 Updates

To update configurations:
```bash
cd ~/dotfiles
git pull
./.install.sh  # Re-run to apply changes
```

## 🐛 Troubleshooting

- **SketchyBar not showing**: Check Accessibility permissions
- **AeroSpace shortcuts not working**: Ensure it has Accessibility permissions
- **Raycast hotkey not working**: Set it manually in System Settings

## 🤝 Contributing

Feel free to submit issues and enhancement requests!