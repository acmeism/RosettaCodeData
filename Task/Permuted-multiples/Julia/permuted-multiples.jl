n = minimum([n for n in 1:2000000 if sort(digits(2n)) == sort(digits(3n)) == sort(digits(4n)) == sort(digits(5n))== sort(digits(6n))])
println("n: $n, 2n: $(2n), 3n: $(3n), 4n: $(4n), 5n: $(5n), 6n: $(6n)")
