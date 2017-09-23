#!/bin/sed -rf
# Convert to uppercase
s/.*/\U&/
# Add lookup table
s/$/\nA.-B-...C-.-.D-..E.F..-.G--.H....I..J.---K-.-L.-..M--N-.O---P.--.Q--.-R.-.S...T-U..-V...-W.--X-..-Y-.--Z--../
# Main loop
:a
s/([A-Z])([^\n]*\n.*\1([-.]+))/\3 \2/
ta
# Remove lookup table
s/\n.*//
