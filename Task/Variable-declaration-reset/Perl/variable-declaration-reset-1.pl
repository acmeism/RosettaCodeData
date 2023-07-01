@s = <1 2 2 3 4 4 5>;
for ($i = 0; $i < 7; $i++) {
    $curr = $s[$i];
    if ($i > 1 and $curr == $prev) { print "$i\n" }
    $prev = $curr;
}
