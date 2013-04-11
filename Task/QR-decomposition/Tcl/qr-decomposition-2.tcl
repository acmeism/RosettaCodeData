set demo [qrDecompose {{12 -51 4} {6 167 -68} {-4 24 -41}}]
puts "==Q=="
print_matrix [lindex $demo 0] "%f"
puts "==R=="
print_matrix [lindex $demo 1] "%.1f"
