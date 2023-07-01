import "timer" for Timer
import "io" for Stdout

System.write("\e[2J")     // clear terminal
System.write("\e[12;40H") // move to (12, 40)
Stdout.flush()
Timer.sleep(2000)
System.write("\e[D")      // move left
Stdout.flush()
Timer.sleep(2000)
System.write("\e[C")      // move right
Stdout.flush()
Timer.sleep(2000)
System.write("\e[A")      // move up
Stdout.flush()
Timer.sleep(2000)
System.write("\e[B")      // move down
Stdout.flush()
Timer.sleep(2000)
System.write("\e[G")      // move to beginning of line
Stdout.flush()
Timer.sleep(2000)
System.write("\e[79C")    // move to end of line (assuming 80 column terminal)
Stdout.flush()
Timer.sleep(2000)
System.write("\e[1;1H")   // move to top left corner
Stdout.flush()
Timer.sleep(2000)
System.write("\e[24;80H") // move to bottom right corner (assuming 80 x 24 terminal)
Stdout.flush()
Timer.sleep(2000)
System.write("\e[1;1H")   // home cursor again before quitting
