set in [open "input.txt"]
set out [open "output.txt" w]
scan [gets $in] "%d %d" x y
puts $out [expr {$x + $y}]
close $in
close $out
