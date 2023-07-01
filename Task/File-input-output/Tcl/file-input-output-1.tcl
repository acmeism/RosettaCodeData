set in [open "input.txt" r]
set out [open "output.txt" w]
# Obviously, arbitrary transformations could be added to the data at this point
puts -nonewline $out [read $in]
close $in
close $out
