my @days = <first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth>;

my @gifts = lines q:to/END/;
  And a partridge in a pear tree.
  Two turtle doves,
  Three french hens,
  Four calling birds,
  Five golden rings,
  Six geese a-laying,
  Seven swans a-swimming,
  Eight maids a-milking,
  Nine ladies dancing,
  Ten lords a-leaping,
  Eleven pipers piping,
  Twelve drummers drumming,
END

sub nth($n) { say "On the @days[$n] day of Christmas, my true love gave to me:" }

nth(0);
say @gifts[0].subst('And a','A');

for 1 ... 11 -> $d {
    say '';
    nth($d);
    say @gifts[$_] for $d ... 0;
}
