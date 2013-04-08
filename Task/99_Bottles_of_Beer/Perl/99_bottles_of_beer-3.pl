use 5.10.0;

$num = 99;
while ($num > 0) {
    my $s = "s" unless ($num == 1);
    say "$num bottle$s of beer on the wall, $num bottle$s of beer";
    $num--;
    my $s = "s" unless ($num == 1);
    $num = "No more" if ($num == 0);
    say "Take one down, pass it around, $num bottle$s of beer on the wall\n"
}

say "No more bottles of beer on the wall, no more bottles of beer.";
say "Go to the store and buy some more, 99 bottles of beer on the wall.";
