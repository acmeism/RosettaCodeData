constant @age-range = 2 .. 102;
my @ages = @age-range.roll(50);
say @ages.&counting-sort ~~ @ages.sort ?? 'ok' !! 'not ok';
