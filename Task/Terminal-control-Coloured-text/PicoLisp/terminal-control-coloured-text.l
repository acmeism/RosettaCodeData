(unless (member (sys "TERM") '("linux" "xterm" "xterm-color" "xterm-256color" "rxvt"))
   (quit "This application requires a colour terminal") )

# Coloured text
(for X '((1 . "Red") (4 . "Blue") (3 . "Yellow"))
   (call 'tput "setaf" (car X))
   (prinl (cdr X)) )

# Blinking
(out '(tput "-S")
   (prinl "setab 1^Jsetaf 3^Jblink") )
(prin "Flashing text")

(call 'tput 'sgr0)   # reset
(prinl)
