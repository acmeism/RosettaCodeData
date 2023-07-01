use utf8;
binmode STDOUT, ":utf8";

use constant STX => '👍 ';

sub transform {
    my($s) = @_;
    my($t);
    warn "String can't contain STX character." and exit if $s =~ /STX/;
    $s = STX . $s;
    $t .= substr($_,-1,1) for sort map { rotate($s,$_) } 1..length($s);
    return $t;
}

sub rotate { my($s,$n) = @_; join '', (split '', $s)[$n..length($s)-1, 0..$n-1] }

sub ɯɹoɟsuɐɹʇ {
    my($s) = @_;
    my @s = split '', $s;
    my @t = sort @s;
    map { @t = sort map { $s[$_] . $t[$_] } 0..length($s)-1 } 1..length($s)-1;
    for (@t) {
        next unless /${\(STX)}$/;  # interpolate the constant
        chop $_ and return $_
    }
}

for $phrase (qw<BANANA dogwood SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES>,
    'TO BE OR NOT TO BE OR WANT TO BE OR NOT?') {
    push @res, 'Original:            '. $phrase;
    push @res, 'Transformed:         '. transform $phrase;
    push @res, 'Inverse transformed: '. ɯɹoɟsuɐɹʇ transform $phrase;
    push @res, '';
}

print join "\n", @res;
