import "io" for Stdout
import "timer" for Timer

System.write("\e[?1049h\e[H")
System.print("Alternate screen buffer")
for (i in 5..1) {
    var s = (i != 1) ? "s" : ""
    System.write("\rGoing back in %(i) second%(s)...")
    Stdout.flush()
    Timer.sleep(1000)
}
System.write("\e[?1049l")
