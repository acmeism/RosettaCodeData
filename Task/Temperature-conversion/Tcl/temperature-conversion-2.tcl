puts -nonewline "Enter a temperature in K: "
flush stdout
lassign [temps [gets stdin]] k c f r
puts [format "K: %.2f" $k]
puts [format "C: %.2f" $c]
puts [format "F: %.2f" $f]
puts [format "R: %.2f" $r]
