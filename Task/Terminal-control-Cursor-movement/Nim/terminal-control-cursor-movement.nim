import terminal

echo "Press the return key to go to next step."
echo "Starting in the middle of last line."

template waitUser() =
  while getch() != '\r': discard

let (width, height) = terminalSize()
# Start by positionning the cursor in the middle of the line.
setCursorXPos(width div 2)
waitUser()
# Move one character backward.
cursorBackward(1)
waitUser()
# Move one character forward.
cursorForward(1)
waitUser()
# Move one character up.
cursorUp(1)
waitUser()
# Move one character down.
cursorDown(1)
waitUser()
# Move at beginning of line.
setCursorXPos(0)
waitUser()
# Move at end of line.
setCursorXPos(width - 1)
waitUser()
# Move cursor to the top left corner.
setCursorPos(0, 0)
waitUser()
# Move cursor to the bottom right corner.
setCursorPos(width - 1, height - 1)
waitUser()
