use strict;
use warnings;
use feature 'say';

my $seq;
for my $x (0..99) {
    my $a = sprintf '%02d', $x;
    next if substr($a,1,1) < substr($a,0,1);
    $seq .= (substr($a,0,1) == substr($a,1,1)) ? substr($a,0,1) : $a;
    for ($a+1 .. 99) {
        next if substr(sprintf('%02d', $_), 1,1) <= substr($a,0,1);
        $seq .= sprintf "%s%02d", $a, $_;
    }
}
$seq .= '000';

sub check {
    my($seq) = @_;
    my %chk;
    for (0.. -1 + length $seq) { $chk{substr($seq, $_, 4)}++ }
    say 'Missing: ' . join ' ', grep { ! $chk{ sprintf('%04d',$_) } } 0..9999;
    say 'Extra:   ' . join ' ', sort grep { $chk{$_} > 1 } keys %chk;
}

my $n = 130;
say "de Bruijn sequence length: " . length $seq;
say "\nFirst $n characters:\n" . substr($seq, 0, $n );
say "\nLast $n characters:\n"  . substr($seq, -$n, $n);
say "\nIncorrect 4 digit PINs in this sequence:";
check $seq;

say "\nIncorrect 4 digit PINs in the reversed sequence:";
check(reverse $seq);

say "\nReplacing the 4444th digit, '@{[substr($seq,4443,1)]}', with '5'";
substr $seq, 4443, 1, 5;
say "Incorrect 4 digit PINs in the revised sequence:";
check $seq;
