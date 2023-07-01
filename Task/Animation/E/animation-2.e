def [reverse, stop] := {
    var text := "Hello World! "
    var leftward := false

    def anim := timer.every(100, fn _ { # milliseconds
        def s := text.size()
        text := if (leftward) {
            text(1, s) + text(0, 1)
        } else {
            text(s - 1, s) + text(0, s - 1)
        }
        print("\b" * s, text)
    })
    print("\n", text)
    anim.start()
    [def _() { leftward := !leftward; null }, anim.stop]
}
