# Project : Terminal control/Hiding the cursor

load "stdlib.ring"
# Linux
? "Hide Cursor using tput utility"
system("tput civis")     # Invisible
sleep(10)
? "Show Cursor using tput utility"
system("tput cnorm")   # Normal
