namespace import ternary::*
puts "x /\\ y == x \\/ y"
puts " x     | y     || result"
puts "-------+-------++--------"
foreach x {true maybe false} {
    foreach y {true maybe false} {
	set z [equiv [and $x $y] [or $x $y]]
	puts [format " %-5s | %-5s || %-5s" $x $y $z]
    }
}
