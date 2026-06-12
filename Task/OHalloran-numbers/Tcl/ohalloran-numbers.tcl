proc calculateOHalloranNumbers { maximumArea } {
    set halfMaximumArea [expr {$maximumArea / 2}]
    set ohalloranNumbers [list]

    # Initialize the ohalloranNumbers list with all true values
    for {set i 0} {$i < $halfMaximumArea} {incr i} {
        lappend ohalloranNumbers true
    }

    # Calculate surface areas of possible cuboids and exclude them
    for {set length 1} {$length < $maximumArea} {incr length} {
        for {set width 1} {$width < $halfMaximumArea} {incr width} {
            for {set height $width} {$height < $halfMaximumArea} {incr height} {
                set halfArea [expr {$length * $width + $length * $height + $width * $height}]
                if {$halfArea < $halfMaximumArea} {
                    lset ohalloranNumbers $halfArea false
                } else {
                    break
                }
            }
            if { $length * $width * 2 >= $halfMaximumArea } {
                break
            }
        }
    }

    # Print out the O'Halloran numbers
    puts "Values larger than 6 and less than $maximumArea which cannot be the surface area of a cuboid:"
    for {set i 3} {$i < $halfMaximumArea} {incr i} {
        if {[lindex $ohalloranNumbers $i]} {
            puts -nonewline "[expr {2 * $i}] "
        }
    }
    puts ""
}

# Call the procedure with the maximum area of 1000
calculateOHalloranNumbers 1000
