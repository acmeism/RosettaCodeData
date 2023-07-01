#!/usr/bin/sh

# play.sh

# Plays .au files.
# Usage: play.sh <recorded_sound.au>

cat $1 >> /dev/audio # Write file $1 to the speaker's Character Special (/dev/audio).
