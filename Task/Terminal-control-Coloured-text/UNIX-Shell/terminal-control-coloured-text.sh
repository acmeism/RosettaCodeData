#!/bin/sh
# Check if the terminal supports colour

# We should know from the TERM evironment variable whether the system
# is comfigured for a colour terminal or not, but we can also check the
# tput utility to check the terminal capability records.

COLORS=8    # Assume initially that the system supports eight colours
case $TERM in
  linux)
    ;;      # We know this is a colour terminal
  rxvt)
    ;;      # We know this is a colour terminal
  *)
    COLORS=`tput colors 2> /dev/null`    # Get the number of colours from the termcap file
esac
if [ -z $COLORS ] ; then
  COLORS=1    # Watch out for an empty returned value
fi

if [ $COLORS -le 2 ] ; then
  # The terminal is not colour
  echo "HW65000 This application requires a colour terminal" >&2
  exit 252    #ERLHW incompatible hardware
fi

# We know at this point that the terminal is colour

# Coloured text
tput setaf 1    #red
echo "Red"
tput setaf 4    #blue
echo "Blue"
tput setaf 3    # yellow
echo "Yellow"

# Blinking
tput setab 1    # red background
tput setaf 3    # yellow foreground
#tput blink     # enable blinking (but does not work on some terminals)
echo "Flashing text"

tput sgr0    # reset everything before exiting
