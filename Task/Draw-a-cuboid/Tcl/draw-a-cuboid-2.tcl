pack [canvas .c -width 400 -height 400]
set cuboid [makeCuboid {2 3 4}]
wm protocol . WM_DELETE_WINDOW { exit }
while 1 {
    incr i
    .c delete all
    set projection [transform::make $i 40 {150 150 100}]
    drawShape .c $cuboid
    update
    after 50
}
