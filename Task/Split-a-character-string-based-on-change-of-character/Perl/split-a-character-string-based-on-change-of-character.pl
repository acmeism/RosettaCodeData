use strict;
use warnings;
use feature 'say';
use utf8;
binmode(STDOUT, ':utf8');

for my $string (q[gHHH5YY++///\\], q[fffn⃗n⃗n⃗»»»  ℵℵ☄☄☃☃̂☃🤔🇺🇸🤦♂️👨‍👩‍👧‍👦]) {
    my @S;
    my $last = '';
    while ($string =~ /(\X)/g) {
        if ($last eq $1) { $S[-1] .= $1 } else { push @S, $1 }
        $last = $1;
    }
    say "Orginal: $string\n  Split: 「" . join('」, 「', @S) . "」\n";
}
