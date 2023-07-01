constant @digits = '0','1','2','3','4','5','6','7','8','9';

# Infinite lazy iterator to generate palindromic "gap" numbers
my @npal = flat [ @digits ], [ '00','11','22','33','44','55','66','77','88','99' ],
  {
    sink @^previous, @^penultimate;
    [ flat @digits.map: -> \digit { @penultimate.map: digit ~ * ~ digit  } ]
  } … *;

# Individual lazy palindromic gapful number iterators for each start/end digit
my @gappal = (1..9).map: -> \digit {
    my \divisor = digit + 10 * digit;
    @npal.map: -> \this { next unless (my \test = digit ~ this ~ digit) %% divisor; test }
}

# Display
( "(Required) First 20 gapful palindromes:",              ^20, 7
  ,"\n(Required) 86th through 100th:",                 85..99, 8
  ,"\n(Optional) 991st through 1,000th:",            990..999, 10
  ,"\n(Extra stretchy) 9,995th through 10,000th:", 9994..9999, 12
  ,"\n(Meh) 100,000th:",                                99999, 14
).hyper(:1batch).map: -> $caption, $range, $fmt {
    my $now = now;
    say $caption;
    put "$_: " ~ @gappal[$_-1][|$range].fmt("%{$fmt}s") for 1..9;
    say round( now - $now, .001 ), " seconds";
}
