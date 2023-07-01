# Utility interfaces to the low-level command
proc capability cap {expr {![catch {exec tput -S << $cap}]}}
proc colorterm {} {expr {[capability setaf] && [capability setab]}}
proc tput args {exec tput -S << $args >/dev/tty}
array set color {black 0 red 1 green 2 yellow 3 blue 4 magenta 5 cyan 6 white 7}
proc foreground x {exec tput -S << "setaf $::color($x)" > /dev/tty}
proc background x {exec tput -S << "setab $::color($x)" > /dev/tty}
proc reset {} {exec tput sgr0 > /dev/tty}

# Demonstration of use
if {[colorterm]} {
    foreground blue
    background yellow
    puts "Color output"
    reset
} else {
    puts "Monochrome only"
}

if {[capability blink]} {
    tput blink
    puts "Blinking output"
    reset
} else {
    puts "Steady only"
}
