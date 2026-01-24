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
- **Browsers**: Firefox, Chrome, Opera GX for web browsing
- **Security**: Bitwarden for password management
- **Database**: DBeaver Community for database management
- **Productivity**: Obsidian for note-taking and knowledge management
- **Gaming**: League of Legends for entertainment
- **Cross-platform**: Crossover for Windows app compatibility
- **DevOps**: Docker Desktop for container development

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

### AeroSpace (Window Manager)
- **Config**: `~/.config/aerospace/aerospace.toml`
- **Keybindings**: 
  - `Alt + H/J/K/L`: Navigate windows
  - `Alt + Shift + H/J/K/L`: Move windows
  - `Alt + 1-9/0`: Switch workspaces
  - `Alt + S/D/E/F`: Change layouts

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