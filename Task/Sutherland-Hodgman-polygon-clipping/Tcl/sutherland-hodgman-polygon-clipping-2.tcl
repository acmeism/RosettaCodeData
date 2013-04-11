package require Tk

grid [canvas .c -width 400 -height 400 -background \#ffffff]
proc demonstrate {cpoly spoly} {
    set rpoly [clippoly $cpoly $spoly]
    puts $rpoly
    .c create polygon $cpoly -outline \#ff9999 -fill {} -width 5
    .c create polygon $spoly -outline \#9999ff -fill {} -width 3
    .c create polygon $rpoly -fill \#99ff99 -outline black -width 1
}

demonstrate {100 100 300 100 300 300 100 300} \
    {50 150 200 50 350 150 350 300 250 300 200 250 150 350 100 250 100 200}
