package require Tk

proc output_jpeg {image filename {quality 75}} {
    set f [open |[list convert ppm:- -quality $quality jpg:- > $filename] w]
    fconfigure $f -translation binary
    puts -nonewline $f [$image data -format ppm]
    close $f
}
