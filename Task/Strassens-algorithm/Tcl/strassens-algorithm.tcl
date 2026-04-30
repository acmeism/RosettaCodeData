# Helper function to create a matrix from nested blocks
proc block_matrix {blocks} {
    set m {}
    set num_hblocks [llength $blocks]
    set num_vblocks [llength [lindex $blocks 0]]

    # Determine dimensions
    set block_height [llength [lindex [lindex $blocks 0] 0]]
    set block_widths {}
    for {set j 0} {$j < $num_vblocks} {incr j} {
        lappend block_widths [llength [lindex [lindex [lindex $blocks 0] $j] 0]]
    }

    # Build the resulting matrix
    for {set i 0} {$i < [expr {$block_height * $num_hblocks}]} {incr i} {
        lappend m {}
    }

    for {set h 0} {$h < $num_hblocks} {incr h} {
        set row_offset [expr {$h * $block_height}]
        for {set i 0} {$i < $block_height} {incr i} {
            set col_offset 0
            for {set v 0} {$v < $num_vblocks} {incr v} {
                set block [lindex [lindex $blocks $h] $v]
                set block_width [lindex $block_widths $v]
                for {set j 0} {$j < $block_width} {incr j} {
                    set row_idx [expr {$row_offset + $i}]
                    set col_idx [expr {$col_offset + $j}]
                    set value [lindex [lindex $block $i] $j]

                    # Extend row if needed
                    set current_row [lindex $m $row_idx]
                    while {[llength $current_row] <= $col_idx} {
                        lappend current_row 0
                    }
                    set current_row [lreplace $current_row $col_idx $col_idx $value]
                    set m [lreplace $m $row_idx $row_idx $current_row]
                }
                incr col_offset $block_width
            }
        }
    }

    return $m
}

# Matrix multiplication (naive)
proc matrix_multiply {a b} {
    set rows_a [llength $a]
    set cols_a [llength [lindex $a 0]]
    set rows_b [llength $b]
    set cols_b [llength [lindex $b 0]]

    if {$cols_a != $rows_b} {
        error "Incompatible matrix dimensions for multiplication"
    }

    set result {}
    for {set i 0} {$i < $rows_a} {incr i} {
        set row {}
        for {set j 0} {$j < $cols_b} {incr j} {
            set sum 0
            for {set k 0} {$k < $cols_a} {incr k} {
                set a_val [lindex [lindex $a $i] $k]
                set b_val [lindex [lindex $b $k] $j]
                set sum [expr {$sum + $a_val * $b_val}]
            }
            lappend row $sum
        }
        lappend result $row
    }

    return $result
}

# Matrix addition
proc matrix_add {a b} {
    set rows [llength $a]
    set cols [llength [lindex $a 0]]

    if {$rows != [llength $b] || $cols != [llength [lindex $b 0]]} {
        error "Matrices must have the same dimensions"
    }

    set result {}
    for {set i 0} {$i < $rows} {incr i} {
        set row {}
        for {set j 0} {$j < $cols} {incr j} {
            set a_val [lindex [lindex $a $i] $j]
            set b_val [lindex [lindex $b $i] $j]
            lappend row [expr {$a_val + $b_val}]
        }
        lappend result $row
    }

    return $result
}

# Matrix subtraction
proc matrix_subtract {a b} {
    set rows [llength $a]
    set cols [llength [lindex $a 0]]

    if {$rows != [llength $b] || $cols != [llength [lindex $b 0]]} {
        error "Matrices must have the same dimensions"
    }

    set result {}
    for {set i 0} {$i < $rows} {incr i} {
        set row {}
        for {set j 0} {$j < $cols} {incr j} {
            set a_val [lindex [lindex $a $i] $j]
            set b_val [lindex [lindex $b $i] $j]
            lappend row [expr {$a_val - $b_val}]
        }
        lappend result $row
    }

    return $result
}

# Get submatrix (using 0-based indexing internally, but interface expects 1-based)
proc get_submatrix {m start_row end_row start_col end_col} {
    # Convert to 0-based indexing
    incr start_row -1
    incr end_row -1
    incr start_col -1
    incr end_col -1

    set result {}
    for {set i $start_row} {$i <= $end_row} {incr i} {
        set row {}
        for {set j $start_col} {$j <= $end_col} {incr j} {
            lappend row [lindex [lindex $m $i] $j]
        }
        lappend result $row
    }
    return $result
}

# Check if number is power of 2
proc is_power_of_2 {n} {
    if {$n <= 0} {return 0}
    return [expr {($n & ($n - 1)) == 0}]
}

# Strassen's algorithm
proc strassen_multiply {a b} {
    set n [llength $a]
    set m [llength [lindex $a 0]]

    if {$n != $m} {
        error "Matrix must be square"
    }
    if {$n != [llength $b] || $n != [llength [lindex $b 0]]} {
        error "Matrices must have the same dimensions"
    }

    # Check if size is a power of 2
    if {![is_power_of_2 $n]} {
        error "Matrix dimension must be a power of 2"
    }

    if {$n == 1} {
        set val [expr {[lindex [lindex $a 0] 0] * [lindex [lindex $b 0] 0]}]
        return [list [list $val]]
    }

    set half [expr {$n / 2}]

    # Partition matrices into quadrants
    set a11 [get_submatrix $a 1 $half 1 $half]
    set a12 [get_submatrix $a 1 $half [expr {$half+1}] $n]
    set a21 [get_submatrix $a [expr {$half+1}] $n 1 $half]
    set a22 [get_submatrix $a [expr {$half+1}] $n [expr {$half+1}] $n]

    set b11 [get_submatrix $b 1 $half 1 $half]
    set b12 [get_submatrix $b 1 $half [expr {$half+1}] $n]
    set b21 [get_submatrix $b [expr {$half+1}] $n 1 $half]
    set b22 [get_submatrix $b [expr {$half+1}] $n [expr {$half+1}] $n]

    # Calculate the seven products
    set m1 [strassen_multiply [matrix_add $a11 $a22] [matrix_add $b11 $b22]]
    set m2 [strassen_multiply [matrix_add $a21 $a22] $b11]
    set m3 [strassen_multiply $a11 [matrix_subtract $b12 $b22]]
    set m4 [strassen_multiply $a22 [matrix_subtract $b21 $b11]]
    set m5 [strassen_multiply [matrix_add $a11 $a12] $b22]
    set m6 [strassen_multiply [matrix_subtract $a21 $a11] [matrix_add $b11 $b12]]
    set m7 [strassen_multiply [matrix_subtract $a12 $a22] [matrix_add $b21 $b22]]

    # Calculate the four quadrants of the result
    set c11 [matrix_add [matrix_subtract [matrix_add $m1 $m4] $m5] $m7]
    set c12 [matrix_add $m3 $m5]
    set c21 [matrix_add $m2 $m4]
    set c22 [matrix_add [matrix_subtract [matrix_add $m1 $m3] $m2] $m6]

    # Combine quadrants into a single matrix
    return [block_matrix [list [list $c11 $c12] [list $c21 $c22]]]
}

# Round matrix values
proc matrix_round {m {digits {}}} {
    set result {}

    if {$digits ne ""} {
        set mult [expr {pow(10, $digits)}]
    }

    for {set i 0} {$i < [llength $m]} {incr i} {
        set row {}
        for {set j 0} {$j < [llength [lindex $m 0]]} {incr j} {
            set val [lindex [lindex $m $i] $j]
            if {$digits ne ""} {
                set rounded [expr {floor($val * $mult + 0.5) / $mult}]
            } else {
                set rounded [expr {floor($val + 0.5)}]
            }
            lappend row $rounded
        }
        lappend result $row
    }

    return $result
}

# Print matrix
proc print_matrix {name m} {
    puts "$name = \{"
    for {set i 0} {$i < [llength $m]} {incr i} {
        puts -nonewline "  \{"
        set row [lindex $m $i]
        for {set j 0} {$j < [llength $row]} {incr j} {
            puts -nonewline [lindex $row $j]
            if {$j < [expr {[llength $row] - 1}]} {
                puts -nonewline ", "
            }
        }
        puts "\}"
    }
    puts "\}"
}

# Examples
proc run_examples {} {
    set a {{1 2} {3 4}}
    set b {{5 6} {7 8}}

    set c {{1 1 1 1} {2 4 8 16} {3 9 27 81} {4 16 64 256}}

    set d {{4 -3 1.333333 -0.25} {-4.333333 4.75 -2.333333 0.458333} {1.5 -2 1.166667 -0.25} {-0.166667 0.25 -0.166667 0.041667}}

    set e {{1 2 3 4} {5 6 7 8} {9 10 11 12} {13 14 15 16}}
    set f {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}}

    puts "Naive matrix multiplication:"
    print_matrix "  a * b" [matrix_multiply $a $b]
    print_matrix "  c * d" [matrix_round [matrix_multiply $c $d] 0]
    print_matrix "  e * f" [matrix_multiply $e $f]

    puts "\nStrassen's matrix multiplication:"
    print_matrix "  a * b" [strassen_multiply $a $b]
    print_matrix "  c * d" [matrix_round [strassen_multiply $c $d] 0]
    print_matrix "  e * f" [strassen_multiply $e $f]
}

# Run examples
run_examples
