#!/bin/bash

# Smart New Tab Script
# Opens a new tab in the current application if supported

# Get the current frontmost application
FRONTMOST_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# Function to handle different applications
open_new_tab() {
    local app_name="$1"
    
    case "$app_name" in
        "Finder")
            # Open new Finder window (equivalent to new tab)
            osascript -e 'tell application "Finder" to make new Finder window'
            ;;
        "iTerm2")
            # Open new iTerm2 tab
            osascript -e 'tell application "iTerm2" to tell current session of current window to create tab with default profile'
            ;;
        "Safari")
            # Open new Safari tab
            osascript -e 'tell application "Safari" to tell window 1 to set current tab to (make new tab with properties {URL:""})'
            ;;
        "Google Chrome"|"Chrome")
            # Open new Chrome tab
            osascript -e 'tell application "Google Chrome" to tell window 1 to set active tab index to (make new tab)'
            ;;
        "Discord")
            # Create/open new channel in Discord
            osascript -e 'tell application "System Events" to keystroke "t" using command down'  # Cmd+T for new channel
            ;;
        "Slack")
            # Create new channel/conversation in Slack
            osascript -e 'tell application "System Events" to keystroke "n" using command down'  # Cmd+N for new conversation
            ;;
        "Obsidian")
            # Open new note in Obsidian
            osascript -e 'tell application "Obsidian" to make new note'
            ;;
        "zoom")
            # Create new meeting in Zoom
            osascript -e 'tell application "System Events" to keystroke "n" using command down'  # Cmd+N for new meeting
            ;;
        "Outlook")
            # New email in Outlook
            osascript -e 'tell application "Microsoft Outlook" to make new email message'
            ;;
        *)
            # Fallback: Try to use standard new shortcut
            osascript -e 'tell application "System Events" to keystroke "n" using command down'
            ;;
    esac
}

# Activate the app and create new tab/window
osascript -e "tell application \"$FRONTMOST_APP\" to activate"
sleep 0.2
open_new_tab "$FRONTMOST_APP"