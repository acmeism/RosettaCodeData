my @c = gather for ^10 -> $i {
    take { $i * $i }
}

.().say for @c.pick(*);  # call them in random order
