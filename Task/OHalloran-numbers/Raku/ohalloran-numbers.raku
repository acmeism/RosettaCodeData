my @Area;

my $threshold = 1000; # a little overboard to make sure we get them all

for 1..$threshold -> $x {
    for 1..$x -> $y {
        last if $x × $y > $threshold;
        for 1..$y -> $z {
           push @Area[my $area = ($x × $y + $y × $z + $z × $x) × 2], "$x,$y,$z";
           last if $area > $threshold;
        }
    }
}

say "Even integer surface areas NOT achievable by any regular, integer dimensioned cuboid:\n" ~
   @Area[^$threshold].kv.grep( { $^key > 6 and $key %% 2 and !$^value } )»[0];
