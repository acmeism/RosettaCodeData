foreach expression {5**3**2 (5**3)**2 5**(3**2)} {
    puts "${expression}:\t[expr $expression]"
}
