# State
var text := "Hello World! "
var leftward := false

# Window
def w := <swing:makeJFrame>("RC: Basic Animation")

# Text in window
w.setContentPane(def l := <swing:makeJLabel>(text))
l.setOpaque(true) # repaints badly if not set!
l.addMouseListener(def mouseListener {
    to mouseClicked(_) {
        leftward := !leftward
    }
    match _ {}
})

# Animation
def anim := timer.every(100, fn _ { # milliseconds
    def s := text.size()
    l.setText(text := if (leftward) {
        text(1, s) + text(0, 1)
    } else {
        text(s - 1, s) + text(0, s - 1)
    })
})

# Set up window shape and close behavior
w.pack()
w.setLocationRelativeTo(null)
w.addWindowListener(def windowListener {
    to windowClosing(_) { anim.stop() }
    match _ {}
})

# Start everything
w.show()
anim.start()
