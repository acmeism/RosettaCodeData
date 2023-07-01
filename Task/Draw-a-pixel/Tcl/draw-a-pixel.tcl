package require Tcl 8.5
package require Tk

pack [canvas .c -width 320 -height 240 -bg #fff] -anchor nw
.c create rectangle 100 100 100 100 -fill #f00 -outline ""
