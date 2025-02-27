import "./ansi" for Screen
import "timer" for Timer

Screen.enableAltBuffer()
System.print("Alternate screen buffer")
for (i in 5..1) {
    var s = (i != 1) ? "s" : ""
    Screen.fwrite("\rGoing back in %(i) second%(s)...")
    Timer.sleep(1000)
}
Screen.disableAltBuffer()
