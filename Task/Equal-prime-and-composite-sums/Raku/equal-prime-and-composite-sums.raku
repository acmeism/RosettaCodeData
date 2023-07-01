use Lingua::EN::Numbers:ver<2.8.2+>;

my $prime-sum =     [\+] (2..*).grep:  *.is-prime;
my $composite-sum = [\+] (2..*).grep: !*.is-prime;

my $c-index = 0;

for ^∞ -> $p-index {
    next if $prime-sum[$p-index] < $composite-sum[$c-index];
    printf( "%20s - %11s prime sum, %12s composite sum   %5.2f seconds\n",
      $prime-sum[$p-index].&comma, ordinal-digit($p-index + 1, :u, :c),
      ordinal-digit($c-index + 1, :u, :c), now - INIT now )
      and next if $prime-sum[$p-index] == $composite-sum[$c-index];
    ++$c-index;
    redo;
};
