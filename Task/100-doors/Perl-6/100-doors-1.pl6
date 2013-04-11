my @doors = False xx 101;

($_ = !$_ for @doors[0, * + $_ ...^ * > 100]) for 1..100;

say "Door $_ is ", <closed open>[ @doors[$_] ] for 1..100;
