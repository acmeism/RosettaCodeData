# Generate the sequence
my $seq;

for ^100 {
    my $a = .fmt: '%02d';
    next if $a.substr(1,1) < $a.substr(0,1);
    $seq ~= ($a.substr(0,1) == $a.substr(1,1)) ?? $a.substr(0,1) !! $a;
    for +$a ^..^ 100 {
        next if .fmt('%02d').substr(1,1) <= $a.substr(0,1);
        $seq ~= sprintf "%s%02d", $a, $_ ;
    }
}

$seq = $seq.comb.list.rotate((^10000).pick).join;

$seq ~= $seq.substr(0,3);

sub check ($seq) {
    my %chk;
    for ^($seq.chars) { %chk{$seq.substr( $_, 4 )}++ }
    put 'Missing: ', (^9999).grep( { not %chk{ .fmt: '%04d' } } ).fmt: '%04d';
    put 'Extra:   ', %chk.grep( *.value > 1 )».key.sort.fmt: '%04d';
}

## The Task
put "de Bruijn sequence length: " ~ $seq.chars;

put "\nFirst 130 characters:\n" ~ $seq.substr( 0, 130 );

put "\nLast 130 characters:\n" ~ $seq.substr( * - 130 );

put "\nIncorrect 4 digit PINs in this sequence:";
check $seq;

put "\nIncorrect 4 digit PINs in the reversed sequence:";
check $seq.flip;

my $digit = $seq.substr(4443,1);
put "\nReplacing the 4444th digit, ($digit) with { ($digit += 1) %= 10 }";
put "Incorrect 4 digit PINs in the revised sequence:";
$seq.substr-rw(4443,1) = $digit;
check $seq;
