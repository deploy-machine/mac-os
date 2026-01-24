#!/bin/bash

# CrossOver GamePorting Toolkit 3.0 Setup Script
# Automates the installation of Apple's Game Porting Toolkit 3.0 with DLSS support
# Based on: https://mybyways.com/blog/updating-crossover-to-gameporting-toolkit-3-0

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

# Configuration
DEVELOPER_ACCOUNT_PROMPT="You need a free Apple Developer account to download Game Porting Toolkit 3.0"
TEMP_DIR="$HOME/Desktop/temp_gptk"
CROSSOVER_APP="/Applications/CrossOver.app"

# Check if CrossOver is installed
if [ ! -d "$CROSSOVER_APP" ]; then
    print_error "CrossOver is not installed. Please install it first using: brew install --cask crossover"
    exit 1
fi

# Step 1: Find and extract GPTK 3.0
print_status "Step 1: Setting up Game Porting Toolkit 3.0"

echo
print_status "Looking for Game Porting Toolkit 3.0 in Downloads folder..."
echo "Note: You need to be logged into your Apple Developer account to download."
echo "Download URL: https://developer.apple.com/downloads/"
echo

# Find the downloaded DMG file (look for common naming variations)
DMG_FILE=""
DMG_PATTERNS=(
    "$HOME/Downloads/Game_Porting_Toolkit_3.0.dmg"
    "$HOME/Downloads/Game_Porting_Toolkit_3.0.dmg/download"
    "$HOME/Downloads/Game*Porting*Toolkit*3.0*.dmg"
    "$HOME/Downloads/GPTK*3.0*.dmg"
)

for pattern in "${DMG_PATTERNS[@]}"; do
    DMG_FILE=$(find ~/Downloads -name "$(basename "$pattern")" 2>/dev/null | head -1)
    if [ -n "$DMG_FILE" ]; then
        break
    fi
done

if [ -z "$DMG_FILE" ]; then
    print_error "Game Porting Toolkit 3.0 DMG not found in Downloads folder."
    echo
    print_status "Please ensure you:"
    echo "  1. Are logged into your Apple Developer account"
    echo "  2. Have downloaded the toolkit from https://developer.apple.com/downloads/"
    echo "  3. The file is in your Downloads folder"
    echo "  4. The file contains 'Game_Porting_Toolkit_3.0' in the name"
    echo
    print_status "Found files in Downloads:"
    ls -la ~/Downloads/*3.0*.dmg 2>/dev/null || echo "  No matching .dmg files found"
    exit 1
fi

print_success "Found Game Porting Toolkit 3.0: $(basename "$DMG_FILE)"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Mount and extract files
print_status "Mounting DMG and extracting files..."
hdiutil attach "$DMG_FILE"

# Wait a moment for mounting
sleep 3

# Find the mounted volume
DMG_MOUNT=$(ls /Volumes | grep "Evaluation environment")
if [ -z "$DMG_MOUNT" ]; then
    print_error "Could not find mounted DMG volume."
    hdiutil detach "/Volumes/Evaluation environment*" 2>/dev/null || true
    exit 1
fi

DMG_PATH="/Volumes/$DMG_MOUNT"

# Copy lib folder to temp directory
print_status "Copying lib folder from Game Porting Toolkit..."
cp -r "$DMG_PATH/redist/lib" "$TEMP_DIR/"

# Unmount DMG
hdiutil detach "$DMG_PATH"

# Step 2: Prepare DLL files
print_status "Step 2: Preparing DLL files..."

# Rename nvngx files in wine subfolders
cd "$TEMP_DIR/lib/wine/x86_64-unix"
if [ -f "nvngx-on-metalfx.so" ]; then
    mv nvngx-on-metalfx.so nvngx.so
    print_success "Renamed nvngx-on-metalfx.so to nvngx.so"
fi

cd "$TEMP_DIR/lib/wine/x86_64-windows"
if [ -f "nvngx-on-metalfx.dll" ]; then
    mv nvngx-on-metalfx.dll nvngx.dll
    print_success "Renamed nvngx-on-metalfx.dll to nvngx.dll"
fi

# Step 3: Get list of CrossOver bottles
print_status "Step 3: Updating CrossOver bottles..."

function get_bottles() {
    # Find CrossOver bottles
    BOTTLES_DIR="$HOME/Library/Application Support/CrossOver/Bottles"
    if [ -d "$BOTTLES_DIR" ]; then
        find "$BOTTLES_DIR" -maxdepth 1 -type d -not -path "$BOTTLES_DIR" -exec basename {} \;
    else
        print_warning "No CrossOver bottles found."
        return 1
    fi
}

BOTTLES=$(get_bottles)
if [ $? -eq 1 ]; then
    print_error "Cannot proceed without CrossOver bottles. Please create a bottle first."
    exit 1
fi

echo "Available CrossOver bottles:"
echo "$BOTTLES" | nl

# Ask which bottle(s) to update
echo
read -p "Enter bottle numbers to update (space-separated, or 'all' for all): " BOTTLE_SELECTIONS
echo

if [ "$BOTTLE_SELECTIONS" = "all" ]; then
    SELECTED_BOTTLES=$(echo "$BOTTLES")
else
    SELECTED_BOTTLES=$(echo "$BOTTLES" | sed -n "${BOTTLE_SELECTIONS// /,}p")
fi

# Step 4: Update each bottle
for BOTTLE in $SELECTED_BOTTLES; do
    if [ -z "$BOTTLE" ]; then
        continue
    fi
    
    print_status "Updating bottle: $BOTTLE"
    
    BOTTLE_DIR="$HOME/Library/Application Support/CrossOver/Bottles/$BOTTLE"
    SYSTEM32_DIR="$BOTTLE_DIR/drive_c/windows/system32"
    
    # Copy DLL files to system32
    if [ -d "$SYSTEM32_DIR" ]; then
        cp "$TEMP_DIR/lib/wine/x86_64-windows/nvngx.dll" "$SYSTEM32_DIR/"
        cp "$TEMP_DIR/lib/wine/x86_64-windows/nvapi64.dll" "$SYSTEM32_DIR/"
        print_success "Copied DLSS DLL files to bottle: $BOTTLE"
    else
        print_warning "Could not find system32 directory for bottle: $BOTTLE"
        continue
    fi
    
    # Update cxbottle.conf
    CxBOTTLE_CONF="$BOTTLE_DIR/cxbottle.conf"
    if [ -f "$CxBOTTLE_CONF" ]; then
        # Backup the original config
        cp "$CxBOTTLE_CONF" "$CxBOTTLE_CONF.backup"
        
        # Add Game Porting Toolkit 3.0 configuration
        cat >> "$CxBOTTLE_CONF" << 'EOF'

[EnvironmentVariables]
;;"PROMPT" = "$p$g"
"CX_BOTTLE_CREATOR_APPID" = "com.codeweavers.c4.12345"
"CX_GRAPHICS_BACKEND" = ""
"WINEMSYNC" = "1"
"D3DM_ENABLE_METALFX" = "1"
"ROSETTA_ADVERTISE_AVX" = "1"
EOF
        
        print_success "Updated cxbottle.conf for bottle: $BOTTLE"
    else
        print_warning "Could not find cxbottle.conf for bottle: $BOTTLE"
    fi
done

# Step 5: Update CrossOver app with GPTK 3.0
print_status "Step 5: Updating CrossOver application with GPTK 3.0"

# Quit CrossOver completely
print_status "Quitting CrossOver..."
osascript -e 'tell application "CrossOver" to quit' 2>/dev/null || true
sleep 2

# Backup existing GPTK folder
GPTK_DIR="$CROSSOVER_APP/Contents/SharedSupport/CrossOver/apple_gptk"
if [ -d "$GPTK_DIR" ]; then
    mv "$GPTK_DIR" "$GPTK_DIR.backup"
    print_success "Backed up existing GPTK folder"
fi

# Create new GPTK folder and copy files
mkdir -p "$GPTK_DIR"
cp -r "$TEMP_DIR/lib/"* "$GPTK_DIR/"
print_success "Updated CrossOver with Game Porting Toolkit 3.0"

# Step 6: Enable Metal Performance HUD
print_status "Step 6: Setting up Metal Performance HUD"

print_success "Game Porting Toolkit 3.0 setup completed!"
echo
print_status "To enable Metal Performance HUD for testing:"
echo "  launchctl setenv MTL_HUD_ENABLED 1"
echo
print_status "To disable Metal Performance HUD:"
echo "  launchctl unsetenv MTL_HUD_ENABLED"
echo
print_status "Testing with a DLSS-enabled game:"
echo "  1. Enable DLSS in the game settings"
echo "  2. Run with Metal HUD enabled to verify MetalFX and GPTK 3.0"
echo "  3. Disable HUD for normal gaming"
echo
print_warning "Remember to quit CrossOver completely before playing games for best performance!"

# Ask about cleanup
read -p "Clean up temporary files? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$TEMP_DIR"
    print_success "Cleaned up temporary files"
else
    print_status "Temporary files kept at: $TEMP_DIR"
fi

echo
print_success "CrossOver Game Porting Toolkit 3.0 setup is complete!"
echo "Enjoy gaming with DLSS support on macOS!"