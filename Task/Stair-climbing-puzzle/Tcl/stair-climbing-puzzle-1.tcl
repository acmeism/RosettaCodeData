set level 41
set prob 0.5001
proc step {} {
    global level prob steps
    incr steps
    if {rand() < $prob} {
	incr level 1
	return 1
    } else {
	incr level -1
	return 0
    }
}
