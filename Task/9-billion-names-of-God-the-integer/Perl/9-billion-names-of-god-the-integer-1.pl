use ntheory qw/:all/;

sub triangle_row {
  my($n,@row) = (shift);
  # Tally by first element of the unrestricted integer partitions.
  forpart { $row[ $_[0] - 1 ]++ } $n;
  @row;
}

printf "%2d: %s\n", $_, join(" ",triangle_row($_)) for 1..25;
print "\n";
say "P($_) = ", partitions($_) for (23, 123, 1234, 12345);
