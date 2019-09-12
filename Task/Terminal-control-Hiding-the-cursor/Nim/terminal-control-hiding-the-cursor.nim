import terminal

echo "Cursor hidden.  Press a key to show the cursor and exit."
stdout.hideCursor()
discard getCh()
stdout.showCursor()
