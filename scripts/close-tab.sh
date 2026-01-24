#!/bin/bash

# Smart Close Tab Script
# Closes the current tab in the current application if supported

# Get the current frontmost application
FRONTMOST_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# Function to handle different applications
close_tab() {
    local app_name="$1"
    
    case "$app_name" in
        "iTerm2")
            # Close current iTerm2 tab
            osascript -e 'tell application "iTerm2" to tell current session of current window to close tab'
            ;;
        "Safari")
            # Close current Safari tab
            osascript -e 'tell application "Safari" to close current tab of window 1'
            ;;
        "Google Chrome"|"Chrome")
            # Close current Chrome tab
            osascript -e 'tell application "Google Chrome" to close active tab of window 1'
            ;;
        "Discord")
            # Close current channel in Discord
            osascript -e 'tell application "System Events" to keystroke "w" using command down'  # Cmd+W to close
            ;;
        "Slack")
            # Close current conversation in Slack
            osascript -e 'tell application "System Events" to keystroke "w" using command down'  # Cmd+W to close
            ;;
        "Obsidian")
            # Close current note in Obsidian
            osascript -e 'tell application "System Events" to keystroke "w" using command down'  # Cmd+W to close
            ;;
        "zoom")
            # Leave meeting/end call in Zoom
            osascript -e 'tell application "System Events" to keystroke "w" using command down'  # Cmd+W to leave meeting
            ;;
        "Outlook")
            # Close current email in Outlook
            osascript -e 'tell application "System Events" to keystroke "w" using command down'  # Cmd+W to close
            ;;
        "Finder")
            # Close current Finder window
            osascript -e 'tell application "Finder" to close front window'
            ;;
        *)
            # Fallback: Try standard close shortcut
            osascript -e 'tell application "System Events" to keystroke "w" using command down'
            ;;
    esac
}

# Activate the app and close tab/window
osascript -e "tell application \"$FRONTMOST_APP\" to activate"
sleep 0.2
close_tab "$FRONTMOST_APP"