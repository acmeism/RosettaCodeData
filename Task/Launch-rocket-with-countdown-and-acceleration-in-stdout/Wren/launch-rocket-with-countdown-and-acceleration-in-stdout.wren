import "timer" for Timer

var rocket = "
    /\\
   (  )
   (  )
  /|/\\|\\
 /_||||_\\
"

var printRocket = Fn.new { |above|
    System.write(rocket)
    if (above == 0) return
    for (i in 1..above) System.print("    ||")
}

var cls = Fn.new { System.write("\x1B[2J") }

// counting
for (n in 5..1) {
    cls.call()
    System.print("%(n) =>")
    printRocket.call(0)
    Timer.sleep(1000)
}

// ignition
cls.call()
System.print("Lifetoff !")
printRocket.call(1)
Timer.sleep(1000)

// liftoff
var ms = 1000
for (n in 2..99) {
    cls.call()
    printRocket.call(n)
    Timer.sleep(ms)
    ms = (ms >= 40) ? ms - 40 : 0
}
