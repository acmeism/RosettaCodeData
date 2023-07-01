#!/bin/sh
tput smcup    # Save the display
echo 'Hello'
sleep 5       # Wait five seconds
tput rmcup    # Restore the display
