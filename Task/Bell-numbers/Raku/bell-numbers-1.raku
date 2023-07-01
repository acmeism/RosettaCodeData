 my @Aitkens-array = lazy [1], -> @b {
     my @c = @b.tail;
     @c.push: @b[$_] + @c[$_] for ^@b;
     @c
 } ... *;

 my @Bell-numbers = @Aitkens-array.map: { .head };

say "First fifteen and fiftieth Bell numbers:";
printf "%2d: %s\n", 1+$_, @Bell-numbers[$_] for flat ^15, 49;

say "\nFirst ten rows of Aitken's array:";
.say for @Aitkens-array[^10];
