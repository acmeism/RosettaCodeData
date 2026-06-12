#!/usr/bin/env tclsh

# Constants
set MAX_SIZE 2500
set EPSILON 0.00000001

# Global variables
set facets [list]
set hull_points [list]
set time_step 0
set edges [list [list] [list]]
set visit_time [list]
set queue [list]
set resfnew [list]
set resfdel [list]
set respt [list]

# Numerical utilities
proc is_greater_than {a b} {
    global EPSILON
    return [expr {($a - $b) > $EPSILON}]
}

proc is_equal {a b} {
    global EPSILON
    return [expr {abs($a - $b) < $EPSILON}]
}

# Vector class implementation
proc vector_create {x y z id} {
    return [dict create x $x y $y z $z id $id]
}

proc vector_subtract {vec1 vec2} {
    set x1 [dict get $vec1 x]
    set y1 [dict get $vec1 y]
    set z1 [dict get $vec1 z]
    set x2 [dict get $vec2 x]
    set y2 [dict get $vec2 y]
    set z2 [dict get $vec2 z]
    return [vector_create [expr {$x1 - $x2}] [expr {$y1 - $y2}] [expr {$z1 - $z2}] 0]
}

proc vector_cross_product {vec1 vec2} {
    set x1 [dict get $vec1 x]
    set y1 [dict get $vec1 y]
    set z1 [dict get $vec1 z]
    set x2 [dict get $vec2 x]
    set y2 [dict get $vec2 y]
    set z2 [dict get $vec2 z]

    set x [expr {$y1 * $z2 - $z1 * $y2}]
    set y [expr {$z1 * $x2 - $x1 * $z2}]
    set z [expr {$x1 * $y2 - $y1 * $x2}]
    return [vector_create $x $y $z 0]
}

proc vector_dot_product {vec1 vec2} {
    set x1 [dict get $vec1 x]
    set y1 [dict get $vec1 y]
    set z1 [dict get $vec1 z]
    set x2 [dict get $vec2 x]
    set y2 [dict get $vec2 y]
    set z2 [dict get $vec2 z]
    return [expr {$x1 * $x2 + $y1 * $y2 + $z1 * $z2}]
}

proc vector_magnitude {vec} {
    set x [dict get $vec x]
    set y [dict get $vec y]
    set z [dict get $vec z]
    return [expr {sqrt($x * $x + $y * $y + $z * $z)}]
}

proc vector_equals {vec1 vec2} {
    set x1 [dict get $vec1 x]
    set y1 [dict get $vec1 y]
    set z1 [dict get $vec1 z]
    set x2 [dict get $vec2 x]
    set y2 [dict get $vec2 y]
    set z2 [dict get $vec2 z]
    return [expr {[is_equal $x1 $x2] && [is_equal $y1 $y2] && [is_equal $z1 $z2]}]
}

# Line class implementation
proc line_create {u v} {
    return [dict create u $u v $v]
}

# Plane class implementation
proc plane_create {u v w} {
    return [dict create u $u v $v w $w]
}

proc plane_normal {plane} {
    set u [dict get $plane u]
    set v [dict get $plane v]
    set w [dict get $plane w]
    set vec1 [vector_subtract $v $u]
    set vec2 [vector_subtract $w $u]
    return [vector_cross_product $vec1 $vec2]
}

proc plane_vector_at_index {plane i} {
    switch $i {
        0 { return [dict get $plane u] }
        1 { return [dict get $plane v] }
        2 { return [dict get $plane w] }
        default { return [vector_create 0 0 0 0] }
    }
}

proc plane_vector_id {plane i} {
    set vec [plane_vector_at_index $plane $i]
    return [dict get $vec id]
}

# Facet class implementation
proc facet_create {id plane} {
    return [dict create id $id plane $plane N [list] visited_time 0 is_deleted false]
}

# Edge class implementation
proc edge_create {} {
    return [dict create netID 0 faceID 0]
}

# Geometric utilities
proc distance_point_plane {vec plane} {
    set u [dict get $plane u]
    set normal [plane_normal $plane]
    set diff [vector_subtract $vec $u]
    set num [vector_dot_product $diff $normal]
    set den [vector_magnitude $normal]
    return [expr {$num / $den}]
}

proc distance_point_line {vec line} {
    set u [dict get $line u]
    set v [dict get $line v]
    set diff1 [vector_subtract $vec $u]
    set length [vector_magnitude $diff1]

    if {$length == 0.0} {
        return 0.0
    }

    set diff2 [vector_subtract $v $u]
    set cross [vector_cross_product $diff2 $diff1]
    set cross_mag [vector_magnitude $cross]
    set line_mag [vector_magnitude $diff2]
    return [expr {$cross_mag / $line_mag}]
}

proc distance_point_point {a b} {
    set diff [vector_subtract $a $b]
    return [vector_magnitude $diff]
}

proc is_above {point plane} {
    set u [dict get $plane u]
    set normal [plane_normal $plane]
    set diff [vector_subtract $point $u]
    set dot [vector_dot_product $diff $normal]
    return [is_greater_than $dot 0.0]
}

# ConvexHull3d class implementation
proc convex_hull_create {index} {
    return [dict create index $index surface_area 0.0]
}

proc get_surface_area {hull_ref} {
    upvar $hull_ref hull
    set surface_area [dict get $hull surface_area]

    if {[is_greater_than $surface_area 0.0]} {
        return $surface_area
    }

    global time_step
    incr time_step
    set index [dict get $hull index]
    set area [dfs_area $index]
    dict set hull surface_area $area
    return $area
}

proc dfs_area {f} {
    global facets time_step
    set facet [lindex $facets $f]

    if {[dict get $facet visited_time] == $time_step} {
        return 0.0
    }

    dict set facet visited_time $time_step
    lset facets $f $facet

    set plane [dict get $facet plane]
    set normal [plane_normal $plane]
    set area [expr {[vector_magnitude $normal] / 2.0}]

    set N [dict get $facet N]
    foreach neighbor $N {
        set area [expr {$area + [dfs_area $neighbor]}]
    }

    return $area
}

proc get_horizon {f point resDel_ref} {
    upvar $resDel_ref resDel
    global facets time_step

    set facet [lindex $facets $f]
    set plane [dict get $facet plane]

    if {![is_above $point $plane]} {
        return 0
    }

    if {[dict get $facet visited_time] == $time_step} {
        return -1
    }

    dict set facet visited_time $time_step
    dict set facet is_deleted true
    lset facets $f $facet
    lappend resDel [dict get $facet id]

    set result -2
    set N [dict get $facet N]

    for {set i 0} {$i < 3} {incr i} {
        set ni [lindex $N $i]
        set horizon [get_horizon $ni $point resDel]

        if {$horizon == 0} {
            set a [plane_vector_id $plane $i]
            set b [plane_vector_id $plane [expr {($i + 1) % 3}]]

            # Handle edges
            global edges visit_time
            for {set idx 0} {$idx < 2} {incr idx} {
                set pt [expr {$idx == 0 ? $a : $b}]
                set facet_id $ni

                if {[lindex $visit_time $pt] != $time_step} {
                    lset visit_time $pt $time_step
                    set edge [edge_create]
                    dict set edge netID [expr {$idx == 0 ? $b : $a}]
                    dict set edge faceID $facet_id
                    lset edges 0 $pt $edge
                } else {
                    set edge [edge_create]
                    dict set edge netID [expr {$idx == 0 ? $b : $a}]
                    dict set edge faceID $facet_id
                    lset edges 1 $pt $edge
                }
            }
            set result $a
        } elseif {$horizon != -1 && $horizon != -2} {
            set result $horizon
        }
    }

    return $result
}

proc prepareConvexHulls {} {
    global hull_points facets edges MAX_SIZE

    # Reserve index 0
    lappend hull_points [list]
    lappend facets [facet_create 0 [plane_create [vector_create 0 0 0 0] [vector_create 0 0 0 0] [vector_create 0 0 0 0]]]

    # Initialize edge vectors
    for {set i 0} {$i < 2} {incr i} {
        set edge_list [list]
        for {set j 0} {$j < $MAX_SIZE} {incr j} {
            lappend edge_list [edge_create]
        }
        lset edges $i $edge_list
    }

    # Initialize visit_time
    global visit_time
    for {set i 0} {$i < $MAX_SIZE} {incr i} {
        lappend visit_time 0
    }
}

proc get_initial_hull {points total_points} {
    global facets hull_points

    # Find extreme points
    set extremes [list]
    for {set i 0} {$i < 6} {incr i} {
        lappend extremes [lindex $points 1]
    }

    for {set i 1} {$i <= $total_points} {incr i} {
        set point [lindex $points $i]
        set x [dict get $point x]
        set y [dict get $point y]
        set z [dict get $point z]

        if {[is_greater_than $x [dict get [lindex $extremes 0] x]]} {
            lset extremes 0 $point
        }
        if {[is_greater_than [dict get [lindex $extremes 1] x] $x]} {
            lset extremes 1 $point
        }
        if {[is_greater_than $y [dict get [lindex $extremes 2] y]]} {
            lset extremes 2 $point
        }
        if {[is_greater_than [dict get [lindex $extremes 3] y] $y]} {
            lset extremes 3 $point
        }
        if {[is_greater_than $z [dict get [lindex $extremes 4] z]]} {
            lset extremes 4 $point
        }
        if {[is_greater_than [dict get [lindex $extremes 5] z] $z]} {
            lset extremes 5 $point
        }
    }

    # Find furthest pair
    set extreme0 [lindex $extremes 0]
    set extreme1 [lindex $extremes 1]
    for {set i 0} {$i < 6} {incr i} {
        for {set j [expr {$i + 1}]} {$j < 6} {incr j} {
            set distance [distance_point_point [lindex $extremes $i] [lindex $extremes $j]]
            if {[is_greater_than $distance [distance_point_point $extreme0 $extreme1]]} {
                set extreme0 [lindex $extremes $i]
                set extreme1 [lindex $extremes $j]
            }
        }
    }

    # Find furthest from line
    set line [line_create $extreme0 $extreme1]
    set extreme2 [lindex $extremes 0]
    for {set i 0} {$i < 6} {incr i} {
        if {[is_greater_than [distance_point_line [lindex $extremes $i] $line] [distance_point_line $extreme2 $line]]} {
            set extreme2 [lindex $extremes $i]
        }
    }

    # Find furthest from plane
    set extreme3 [lindex $points 1]
    set basePlane [plane_create $extreme0 $extreme1 $extreme2]
    for {set i 1} {$i <= $total_points} {incr i} {
        set distance1 [expr {abs([distance_point_plane [lindex $points $i] $basePlane])}]
        set distance2 [expr {abs([distance_point_plane $extreme3 $basePlane])}]
        if {[is_greater_than $distance1 $distance2]} {
            set extreme3 [lindex $points $i]
        }
    }

    if {[is_greater_than 0 [distance_point_plane $extreme3 $basePlane]]} {
        set temp $extreme1
        set extreme1 $extreme2
        set extreme2 $temp
    }

    # Create 4 initial facets
    set f [list]
    for {set i 0} {$i < 4} {incr i} {
        set facet_id [llength $facets]
        set plane [plane_create $extreme0 $extreme1 $extreme2]
        lappend facets [facet_create $facet_id $plane]
        lappend f $facet_id
    }

    # Set up planes
    set f0 [lindex $f 0]
    set f1 [lindex $f 1]
    set f2 [lindex $f 2]
    set f3 [lindex $f 3]

    set facet0 [lindex $facets $f0]
    dict set facet0 plane [plane_create $extreme0 $extreme2 $extreme1]
    lset facets $f0 $facet0

    set facet1 [lindex $facets $f1]
    dict set facet1 plane [plane_create $extreme0 $extreme1 $extreme3]
    lset facets $f1 $facet1

    set facet2 [lindex $facets $f2]
    dict set facet2 plane [plane_create $extreme1 $extreme2 $extreme3]
    lset facets $f2 $facet2

    set facet3 [lindex $facets $f3]
    dict set facet3 plane [plane_create $extreme2 $extreme0 $extreme3]
    lset facets $f3 $facet3

    # Set neighbors
    set facet0 [lindex $facets $f0]
    dict set facet0 N [list $f3 $f2 $f1]
    lset facets $f0 $facet0

    set facet1 [lindex $facets $f1]
    dict set facet1 N [list $f0 $f2 $f3]
    lset facets $f1 $facet1

    set facet2 [lindex $facets $f2]
    dict set facet2 N [list $f0 $f3 $f1]
    lset facets $f2 $facet2

    set facet3 [lindex $facets $f3]
    dict set facet3 N [list $f0 $f1 $f2]
    lset facets $f3 $facet3

    # Prepare hull_points
    for {set i 0} {$i < 4} {incr i} {
        lappend hull_points [list]
    }

    # Assign points
    for {set i 1} {$i <= $total_points} {incr i} {
        set point [lindex $points $i]
        if {[vector_equals $point $extreme0] || [vector_equals $point $extreme1] ||
            [vector_equals $point $extreme2] || [vector_equals $point $extreme3]} {
            continue
        }

        for {set j 0} {$j < 4} {incr j} {
            set fj [lindex $f $j]
            set facet [lindex $facets $fj]
            set plane [dict get $facet plane]
            if {[is_above $point $plane]} {
                set current_points [lindex $hull_points $fj]
                lappend current_points $point
                lset hull_points $fj $current_points
                break
            }
        }
    }

    return [convex_hull_create $f0]
}

proc QuickHull3D {points total_points} {
    global queue facets hull_points time_step resfdel resfnew respt edges visit_time

    set hull [get_initial_hull $points $total_points]

    # Initialize queue
    set queue [list]
    set hull_index [dict get $hull index]
    lappend queue $hull_index

    set facet [lindex $facets $hull_index]
    set N [dict get $facet N]
    foreach neighbor $N {
        lappend queue $neighbor
    }

    set new_horizon 0

    while {[llength $queue] > 0} {
        set nf [lindex $queue 0]
        set queue [lrange $queue 1 end]

        set facet [lindex $facets $nf]
        if {[dict get $facet is_deleted] || [llength [lindex $hull_points $nf]] == 0} {
            if {![dict get $facet is_deleted]} {
                set new_horizon $nf
            }
            continue
        }

        # Find farthest point
        set point_list [lindex $hull_points $nf]
        set point [lindex $point_list 0]
        set plane [dict get $facet plane]

        foreach vec $point_list {
            if {[is_greater_than [distance_point_plane $vec $plane] [distance_point_plane $point $plane]]} {
                set point $vec
            }
        }

        # Find horizon
        incr time_step
        set resfdel [list]
        set horizon [get_horizon $nf $point resfdel]

        # Build new faces
        set resfnew [list]
        incr time_step
        set from -1
        set last_f -1
        set first_f -1

        while {[lindex $visit_time $horizon] != $time_step} {
            lset visit_time $horizon $time_step

            if {[dict get [lindex $edges 0 $horizon] netID] == $from} {
                set net [dict get [lindex $edges 1 $horizon] netID]
                set f [dict get [lindex $edges 1 $horizon] faceID]
            } else {
                set net [dict get [lindex $edges 0 $horizon] netID]
                set f [dict get [lindex $edges 0 $horizon] faceID]
            }

            # Create new facet
            set new_f [llength $facets]
            set facet_f [lindex $facets $f]
            set plane_f [dict get $facet_f plane]

            # Find indices
            set pt1 0
            set pt2 0
            for {set i 0} {$i < 3} {incr i} {
                set vec_at_i [plane_vector_at_index $plane_f $i]
                if {[vector_equals [lindex $points $horizon] $vec_at_i]} {
                    set pt1 $i
                }
                if {[vector_equals [lindex $points $net] $vec_at_i]} {
                    set pt2 $i
                }
            }
            if {[expr {($pt1 + 1) % 3}] != $pt2} {
                set temp $pt1
                set pt1 $pt2
                set pt2 $temp
            }

            set new_plane [plane_create [plane_vector_at_index $plane_f $pt2] [plane_vector_at_index $plane_f $pt1] $point]
            lappend facets [facet_create $new_f $new_plane]
            lappend hull_points [list]
            lappend resfnew $new_f

            # Set neighbors
            set new_facet [lindex $facets $new_f]
            set N [dict get $new_facet N]
            lset N 0 $f
            dict set new_facet N $N
            lset facets $new_f $new_facet

            set facet_f [lindex $facets $f]
            set N_f [dict get $facet_f N]
            lset N_f $pt1 $new_f
            dict set facet_f N $N_f
            lset facets $f $facet_f

            if {$last_f >= 0} {
                # Link with previous new facet
                set new_facet [lindex $facets $new_f]
                set last_facet [lindex $facets $last_f]
                set new_plane [dict get $new_facet plane]
                set last_plane [dict get $last_facet plane]

                if {[vector_equals [plane_vector_at_index $new_plane 1] [dict get $last_plane u]]} {
                    set N [dict get $new_facet N]
                    lset N 1 $last_f
                    dict set new_facet N $N
                    lset facets $new_f $new_facet

                    set N [dict get $last_facet N]
                    lset N 2 $new_f
                    dict set last_facet N $N
                    lset facets $last_f $last_facet
                } else {
                    set N [dict get $new_facet N]
                    lset N 2 $last_f
                    dict set new_facet N $N
                    lset facets $new_f $new_facet

                    set N [dict get $last_facet N]
                    lset N 1 $new_f
                    dict set last_facet N $N
                    lset facets $last_f $last_facet
                }
            } else {
                set first_f $new_f
            }

            set last_f $new_f
            set from $horizon
            set horizon $net
        }

        # Close the loop
        if {$first_f >= 0 && $last_f >= 0} {
            set first_facet [lindex $facets $first_f]
            set last_facet [lindex $facets $last_f]
            set first_plane [dict get $first_facet plane]
            set last_plane [dict get $last_facet plane]

            if {[vector_equals [plane_vector_at_index $first_plane 1] [dict get $last_plane u]]} {
                set N [dict get $first_facet N]
                lset N 1 $last_f
                dict set first_facet N $N
                lset facets $first_f $first_facet

                set N [dict get $last_facet N]
                lset N 2 $first_f
                dict set last_facet N $N
                lset facets $last_f $last_facet
            } else {
                set N [dict get $first_facet N]
                lset N 2 $last_f
                dict set first_facet N $N
                lset facets $first_f $first_facet

                set N [dict get $last_facet N]
                lset N 1 $first_f
                dict set last_facet N $N
                lset facets $last_f $last_facet
            }
        }

        # Collect deleted points
        set respt [list]
        foreach f_id $resfdel {
            set deleted_points [lindex $hull_points $f_id]
            set respt [concat $respt $deleted_points]
            lset hull_points $f_id [list]
        }

        # Reassign points
        foreach vec $respt {
            if {[vector_equals $vec $point]} {
                continue
            }
            foreach f_id $resfnew {
                set facet [lindex $facets $f_id]
                set plane [dict get $facet plane]
                if {[is_above $vec $plane]} {
                    set current_points [lindex $hull_points $f_id]
                    lappend current_points $vec
                    lset hull_points $f_id $current_points
                    break
                }
            }
        }

        # Enqueue new faces
        foreach f_id $resfnew {
            lappend queue $f_id
        }
    }

    dict set hull index $new_horizon
    return $hull
}

# Main execution
proc main {} {
    prepareConvexHulls

    # Example: a tetrahedron
    set n 4
    set points [list]

    # points[0] is placeholder
    lappend points [vector_create 0 0 0 0]
    lappend points [vector_create 0 0 0 1]
    lappend points [vector_create 1 0 0 2]
    lappend points [vector_create 0 1 0 3]
    lappend points [vector_create 0 0 1 4]

    set hull [QuickHull3D $points $n]
    set surface_area [get_surface_area hull]
    puts [format "%.3f" $surface_area]
}

# Run the main function
main
