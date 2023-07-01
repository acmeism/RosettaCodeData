set n 100
puts "calculate $n rows:"
foreach proc {pascal_iterative pascal_coefficients pascal_combinations} {
    puts "$proc: [time [list $proc $n] 100]"
}
