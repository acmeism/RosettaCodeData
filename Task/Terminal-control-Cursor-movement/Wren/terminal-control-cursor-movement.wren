import "./ansi" for Screen, Cursor
import "timer" for Timer

Screen.clear()        // clear terminal
Cursor.move(12, 40)   // move to (12, 40)
Timer.sleep(2000)
Cursor.left           // move left
Timer.sleep(2000)
Cursor.right          // move right
Timer.sleep(2000)
Cursor.up             // move up
Timer.sleep(2000)
Cursor.down           // move down
Timer.sleep(2000)
Cursor.column         // move to beginning of line
Timer.sleep(2000)
Cursor.column(80)     // move to end of line (assuming 80 column terminal)
Timer.sleep(2000)
Cursor.home           // move to top left corner
Timer.sleep(2000)
Cursor.move(24, 80)   // move to bottom right corner (assuming 80 x 24 terminal)
Timer.sleep(2000)
Cursor.home           // home cursor again before quitting
