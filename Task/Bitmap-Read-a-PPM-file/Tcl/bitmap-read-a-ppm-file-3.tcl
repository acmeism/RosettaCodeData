package require Tk

proc grayscaleFile {filename {newFilename ""}} {
    set buffer [image create photo]
    if {$newFilename eq ""} {set newFilename $filename}
    try {
        $buffer read $filename -format ppm
        $buffer write $newFilename -format ppm -grayscale
    } finally {
        image delete $buffer
    }
}
