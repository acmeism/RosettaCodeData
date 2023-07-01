set f [open example.csv r]
puts "[gets $f],SUM"
while { [gets $f row] > 0 } {
	puts "$row,[expr [string map {, +} $row]]"
}
close $f
