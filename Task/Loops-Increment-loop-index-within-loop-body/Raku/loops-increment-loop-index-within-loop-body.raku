# the actual sequence logic
my @seq = grep *.is-prime, (42, { .is-prime ?? $_+<1 !! $_+1 } … *);

# display code
say (1+$_).fmt("%-4s"), @seq[$_].flip.comb(3).join(',').flip.fmt("%20s") for ^42;
