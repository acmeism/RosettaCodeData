set x1 [Err 100 1.1]
set x2 [Err 200 2.2]
set y1 [Err 50 1.2]
set y2 [Err 100 2.3]
# Evaluate in a local context to clean up intermediate objects
set d [scope {
    [[[$x1 - $x2] ** 2] + [[$y1 - $y2] ** 2]] ** 0.5
}]
puts "d = [$d p]"
