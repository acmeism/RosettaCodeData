oo::class create Point {
    variable x y
    constructor {X Y} {set x $X;set y $Y}
    method x {args} {set x {*}$args}
    method y {args} {set y {*}$args}
    method show {} {return "{$x,$y}"}
}
Point create point 4 5
point y 7
puts "Point is [point show]"
