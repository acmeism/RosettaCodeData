$n = scalar <>;

for (1..$n) {
    ($a,$b) = split ' ', <>;
    print $a + $b . "\n";
}
