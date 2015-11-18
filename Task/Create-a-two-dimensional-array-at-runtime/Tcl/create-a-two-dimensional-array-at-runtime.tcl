puts "Enter width:"
set width [gets stdin]
puts "Enter height:"
set height [gets stdin]
# Initialize array
for {set i 0} {$i < $width} {incr i} {
	for {set j 0} {$j < $height} {incr j} {
		set arr($i,$j) ""
	}
}
# Store value
set arr(0,0) "abc"
# Print value
puts "Element (0/0): $arr(0,0)"
# Cleanup array
unset arr
