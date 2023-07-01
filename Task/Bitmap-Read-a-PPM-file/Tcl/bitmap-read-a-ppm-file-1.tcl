package require Tk

proc readPPM {image file} {
    $image read $file -format ppm
}
