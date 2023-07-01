say my $bag = (1, '1', '1', <1 1 1>).Bag;
say $bag{ 1 }; # how many 1s?
say $bag{'1'}; # wait, how many?
say $bag< 1 >; # WAT
dd $bag; # The different numeric types LOOK the same, but are different types behind the scenes
