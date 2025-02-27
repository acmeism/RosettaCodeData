import "./ansi" for Screen
import "timer" for Timer

var colors = ["Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White"]

// display words using 'bright' colors
for (i in 1..7)  Screen.print(colors[i], colors[i]) // Red to White

Timer.sleep(3000)            // wait for 3 seconds
Screen.setBackColor("white") // set background color to white
Screen.clear()               // clear screen to background color & home the cursor

// display words again using 'blinking' colors
Screen.setStyle("blink")     // blink on
for (i in 0..6) Screen.print(colors[i], colors[i]) // Black to Cyan

Timer.sleep(3000)            // wait for 3 more seconds
Screen.reset()               // reset all attributes
Screen.clear()               // clear screen to background color & home the cursor
