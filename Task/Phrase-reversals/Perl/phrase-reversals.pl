use feature 'say';
my $s = "rosetta code phrase reversal";

say "0. Input               : ", $s;
say "1. String reversed     : ", scalar reverse $s;
say "2. Each word reversed  : ", join " ", reverse split / /, reverse $s;
say "3. Word-order reversed : ", join " ", reverse split / /,$s;

# Or, using a regex:
say "2. Each word reversed  : ", $s =~ s/[^ ]+/reverse $&/gre;
