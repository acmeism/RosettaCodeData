let x = [1 2 3]

print $x

# Both are equivalent
print $x.1 ($x | get 1)

# Shadowing the original x
let x = $x | append 4
print $x

# Using mut
mut y = [a b c]
print $y
$y = $y | append d
print $y
