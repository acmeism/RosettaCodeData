my @ages = map {int(rand(140))} 1 .. 100;

counting_sort(\@ages, 0, 140);
print join("\n", @ages), "\n";
