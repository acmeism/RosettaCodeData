#!/bin/zsh
string='abcdefghijk'
echo ${string:2:3}              # Display 3 chars starting 2 chars in ie: 'cde'
echo ${string:2}                # Starting 2 chars in, display to end of string
echo ${string:0:${#string}-1}   # Whole string minus last character
echo ${string%?}                 # Shorter variant of the above
echo ${${string/*c/c}:0:3}      # Display 3 chars starting with 'c'
echo ${${string/*cde/cde}:0:3}  # Display 3 chars starting with 'cde'
