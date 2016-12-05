import Terminal
setForegroundColor(fgRed)
echo "FATAL ERROR! Cannot write to /boot/vmlinuz-3.2.0-33-generic"

setBackgroundColor(bgBlue)
setForegroundColor(fgYellow)
stdout.write "This is an "
writeStyled  "important"
stdout.write " word"
resetAttributes()
stdout.write "\n"

setForegroundColor(fgYellow)
echo "RosettaCode!"

setForegroundColor(fgCyan)
echo "RosettaCode!"

setForegroundColor(fgGreen)
echo "RosettaCode!"

setForegroundColor(fgMagenta)
echo "RosettaCode!"
