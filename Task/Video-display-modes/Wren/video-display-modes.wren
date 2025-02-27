import "os" for Process
import "timer" for Timer

// query supported display modes
Process.exec("xrandr -q")

Timer.wait(3000)

// change display mode to 1368x768
System.print("\nChanging to 1368 x 768 mode.")
Process.exec("xrandr -s 1368x768")

Timer.wait(3000)

// change it back again to 1920x1080
System.print("\nReverting to 1920 x 1080 mode.")
Process.exec("xrandr -s 1920x1080")
