import "timer" for Timer

var colors = ["Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White"]

// display words using 'bright' colors
for (i in 1..7) System.print("\e[%(30+i);1m%(colors[i])") // red to white
Timer.sleep(3000)         // wait for 3 seconds
System.write("\e[47m")    // set background color to white
System.write("\e[2J")     // clear screen to background color
System.write("\e[H")      // home the cursor

// display words again using 'blinking' colors
System.write("\e[5m")     // blink on
for (i in 0..6) System.print("\e[%(30+i);1m%(colors[i])") // black to cyan
Timer.sleep(3000)         // wait for 3 more seconds
System.write("\e[0m")     // reset all attributes
System.write("\e[2J")     // clear screen to background color
System.write("\e[H")      // home the cursor
