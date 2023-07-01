use List::Util qw(reduce);
$sum = reduce { $a + 1 / $b ** 2 } 0, 1..1000;
print "$sum\n";
