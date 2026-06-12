use strict;
use warnings;
use List::Util 'sum';

sub lgamma {
  my $x = shift;
  my $log_sqrt_two_pi = 0.91893853320467274178;
  my @lanczos_coef = (
      0.99999999999980993, 676.5203681218851, -1259.1392167224028,
      771.32342877765313, -176.61502916214059, 12.507343278686905,
      -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7 );
  my $base = $x + 7.5;
  my $sum = 0;
  $sum += $lanczos_coef[$_] / ($x + $_)  for reverse (1..8);
  $sum += $lanczos_coef[0];
  $sum = $log_sqrt_two_pi + log($sum/$x) + ( ($x+0.5)*log($base) - $base );
  $sum;
}

sub calculate_P_value {
    my ($array1,$array2) = (shift, shift);
    return 1 if @$array1 <= 1 or @$array2 <= 1;

    my $mean1 = sum(@$array1);
    my $mean2 = sum(@$array2);
    $mean1 /= scalar @$array1;
    $mean2 /= scalar @$array2;
    return 1 if $mean1 == $mean2;

    my ($variance1,$variance2);
    $variance1 += ($mean1-$_)**2 for @$array1;
    $variance2 += ($mean2-$_)**2 for @$array2;
    return 1 if $variance1 == 0 and $variance2 == 0;

    $variance1 = $variance1/(@$array1-1);
    $variance2 = $variance2/(@$array2-1);
    my $Welch_t_statistic = ($mean1-$mean2)/sqrt($variance1/@$array1+$variance2/@$array2);
    my $DoF = (($variance1/@$array1+$variance2/@$array2)**2) /
                (
                 ($variance1*$variance1)/(@$array1*@$array1*(@$array1-1)) +
                 ($variance2*$variance2)/(@$array2*@$array2*(@$array2-1))
                );
    my $A     = $DoF / 2;
    my $value = $DoF / ($Welch_t_statistic**2 + $DoF);
    return $value if $A <= 0 or $value <= 0 or 1 <= $value;

    # from here, translation of John Burkhardt's C code
    my $beta = lgamma($A) + 0.57236494292470009 - lgamma($A+0.5); # constant is lgamma(.5), but more precise than 'lgamma' routine
    my $eps = 10**-15;
    my($ai,$cx,$indx,$ns,$pp,$psq,$qq,$qq_ai,$rx,$term,$xx);

    $psq = $A + 0.5;
    $cx = 1 - $value;
    if ($A < $psq * $value) { ($xx, $cx, $pp, $qq, $indx) = ($cx,   $value, 0.5,  $A, 1) }
    else                    { ($xx,      $pp, $qq, $indx) = ($value,         $A, 0.5, 0) }
    $term = $ai = $value = 1;
    $ns = int $qq + $cx * $psq;

    # Soper reduction formula
    $qq_ai = $qq - $ai;
    $rx = $ns == 0 ? $xx : $xx / $cx;
    while (1) {
        $term = $term * $qq_ai * $rx / ( $pp + $ai );
        $value = $value + $term;
        $qq_ai = abs($term);
        if ($qq_ai <= $eps && $qq_ai <= $eps * $value) {
           $value = $value * exp ($pp * log($xx) + ($qq - 1) * log($cx) - $beta) / $pp;
           $value = 1 - $value if $indx;
           last;
        }
        $ai++;
        $ns--;
        if ($ns >= 0) {
            $qq_ai = $qq - $ai;
            $rx = $xx if $ns == 0;
        } else {
            $qq_ai = $psq;
            $psq = $psq + 1;
        }
    }
    $value
}

my @answers = (
0.021378001462867,
0.148841696605327,
0.0359722710297968,
0.090773324285671,
0.0107515611497845,
0.00339907162713746,
0.52726574965384,
0.545266866977794,
);

my @tests = (
    [27.5,21.0,19.0,23.6,17.0,17.9,16.9,20.1,21.9,22.6,23.1,19.6,19.0,21.7,21.4],
    [27.1,22.0,20.8,23.4,23.4,23.5,25.8,22.0,24.8,20.2,21.9,22.1,22.9,20.5,24.4],

    [17.2,20.9,22.6,18.1,21.7,21.4,23.5,24.2,14.7,21.8],
    [21.5,22.8,21.0,23.0,21.6,23.6,22.5,20.7,23.4,21.8,20.7,21.7,21.5,22.5,23.6,21.5,22.5,23.5,21.5,21.8],

    [19.8,20.4,19.6,17.8,18.5,18.9,18.3,18.9,19.5,22.0],
    [28.2,26.6,20.1,23.3,25.2,22.1,17.7,27.6,20.6,13.7,23.2,17.5,20.6,18.0,23.9,21.6,24.3,20.4,24.0,13.2],

    [30.02,29.99,30.11,29.97,30.01,29.99],
    [29.89,29.93,29.72,29.98,30.02,29.98],

    [3.0,4.0,1.0,2.1],
    [490.2,340.0,433.9],

    [0.010268,0.000167,0.000167],
    [0.159258,0.136278,0.122389],

    [1.0/15,10.0/62.0],
    [1.0/10,2/50.0],

    [9/23.0,21/45.0,0/38.0],
    [0/44.0,42/94.0,0/22.0],
);

my $error = 0;
while (@tests) {
    my ($left, $right) = splice(@tests, 0, 2);
    my $pvalue = calculate_P_value($left,$right);
    $error += abs($pvalue - shift @answers);
    printf("p-value = %.14g\n",$pvalue);
}
printf("cumulative error is %g\n", $error);
