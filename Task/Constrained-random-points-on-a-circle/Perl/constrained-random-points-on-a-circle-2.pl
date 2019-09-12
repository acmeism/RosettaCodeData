@range = -15..16;

for $x (@range) {
    for $y (@range) {
        $radius = sqrt $x**2 + $y**2;
        push @points, [$x,$y] if 10 <= $radius and $radius <= 15
    }
}

push @sample, @points[int rand @points] for 1..100;
push @matrix, ' ' x @range for 1..@range;
substr $matrix[15+$$_[1]], 15+$$_[0], 1, '*' for @sample;
print join(' ', split '', $_) . "\n" for @matrix;
