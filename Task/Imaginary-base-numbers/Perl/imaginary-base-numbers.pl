use strict;
use warnings;
use feature 'say';

use Math::Complex;
use List::AllUtils qw(sum mesh);
use ntheory qw<todigitstring fromdigits>;

sub zip {
    my($a,$b) = @_;
    my($la, $lb) = (length $a, length $b);
    my $l = '0' x abs $la - $lb;
    $a .= $l if $la < $lb;
    $b .= $l if $lb < $la;
    (join('', mesh(@{[split('',$a),]}, @{[split('',$b),]})) =~ s/0+$//r) or 0;
}

sub base_i {
    my($num,$radix,$precision) = @_;
    die unless $radix > -37 and $radix < -1;
    return '0' unless $num;
    my $value  = $num;
    my $result = '';
    my $place  = 0;
    my $upper_bound = 1 / (-$radix + 1);
    my $lower_bound = $radix * $upper_bound;

    $value = $num / $radix ** ++$place until $lower_bound <= $value and $value < $upper_bound;

    while (($value or $place > 0) and $place > $precision) {
        my $digit = int $radix * $value - $lower_bound;
        $value    =  $radix * $value - $digit;
        $result  .= '.' unless $place or not index($result, '.');
        $result  .= $digit == -$radix ? todigitstring($digit-1, -$radix) . '0' : (todigitstring($digit, -$radix) or '0');
        $place--;
    }
    $result
}

sub base_c {
    my($num, $radix, $precision) = @_;
    die "Base $radix out of range" unless
        (-6 <= $radix->Im or $radix->Im <= -2) or (2 <= $radix->Im or $radix->Im <= 6);
    my ($re,$im);
    defined $num->Im ? ($re, $im) = ($num->Re, $num->Im) : $re = $num;
    my ($re_wh, $re_fr) = split /\./, base_i(  $re,               -1 * int($radix->Im**2), $precision);
    my ($im_wh, $im_fr) = split /\./, base_i( ($im/($radix->Im)), -1 * int($radix->Im**2), $precision);
    $_ //= '' for $re_fr, $im_fr;

    my $whole = reverse zip scalar reverse($re_wh), scalar reverse($im_wh);
    my $fraction = zip $im_fr, $re_fr;
    $fraction eq 0 ? "$whole" : "$whole.$fraction"
}

sub parse_base {
    my($str, $radix) = @_;
    return -1 * parse_base( substr($str,1), $radix) if substr($str,0,1) eq '-';
    my($whole, $frac) = split /\./, $str;
    my $fraction = 0;
    my $k = 0;
    $fraction = sum map { (fromdigits($_, int $radix->Im**2) || 0) * $radix ** -($k++ +1) } split '', $frac
        if $frac;
    $k = 0;
    $fraction + sum map { (fromdigits($_, int $radix->Im**2) || 0) * $radix ** $k++  } reverse split '', $whole;
}

for (
    [  0*i,  2*i], [1+0*i,  2*i], [5+0*i,      2*i], [ -13+0*i, 2*i],
    [  9*i,  2*i], [ -3*i,  2*i], [7.75-7.5*i, 2*i], [0.25+0*i, 2*i],
    [5+5*i,  2*i], [5+5*i,  3*i], [5+5*i,  4*i], [5+5*i,  5*i], [5+5*i,  6*i],
    [5+5*i, -2*i], [5+5*i, -3*i], [5+5*i, -4*i], [5+5*i, -5*i], [5+5*i, -6*i]
) {
    my($v,$r) = @$_;
    my $ibase = base_c($v, $r, -6);
    my $rt = cplx parse_base($ibase, $r);
    $rt->display_format('format' => '%.2f');
    printf "base(%3s): %10s  => %9s  => %13s\n", $r, $v, $ibase, $rt;
}

say '';
say 'base( 6i): 31432.6219135802-2898.5266203704*i => ' .
         base_c(31432.6219135802-2898.5266203704*i, 0+6*i, -3);
