use v5.12;
use utf8;
binmode STDOUT, ':utf8';

my($lower,$upper);

for my $i (0..2**8-1) {
    my $c = chr $i;
    $lower .= $c if $c =~ /[[:lower:]]/;
    $upper .= $c if $c =~ /[[:upper:]]/;
}

say $lower;
say $upper;
