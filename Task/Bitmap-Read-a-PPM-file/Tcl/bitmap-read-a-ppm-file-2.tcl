package require Tk

proc grayscaleFile {filename {newFilename ""}} {
    set buffer [image create photo]
    if {$newFilename eq ""} {set newFilename $filename}
    try {
        $buffer read $filename -format ppm
        set w [image width $buffer]
        set h [image height $buffer]
        for {set x 0} {$x<$w} {incr x} {
            for {set y 0} {$y<$h} {incr y} {
                lassign [$buffer get $x $y] r g b
                set l [expr {int(0.2126*$r + 0.7152*$g + 0.0722*$b)}]
                $buffer put [format "#%02x%02x%02x" $l $l $l] -to $x $y
            }
        }
        $buffer write $newFilename -format ppm
    } finally {
        image delete $buffer
    }
}
