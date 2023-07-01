use feature 'state';
use DateTime;
my @month_names = qw{
    Vendémiaire Brumaire Frimaire  Nivôse   Pluviôse  Ventôse
    Germinal    Floréal  Prairial  Messidor Thermidor Fructidor
};
my @intercalary = (
    'Fête de la vertu',  'Fête du génie',        'Fête du travail',
    "Fête de l'opinion", 'Fête des récompenses', 'Fête de la Révolution',
);
my %month_nums  = map { $month_names[$_] => $_+1 } 0 .. $#month_names;
my %i_cal_nums  = map { $intercalary[$_] => $_+1 } 0 .. $#intercalary;
my $i_cal_month = 13;
my $epoch       = DateTime->new( year => 1792, month => 9, day => 22 );

sub is_republican_leap_year {
    my $y = $_[0] + 1;
    return !!( ($y % 4)==0 and (($y % 100)!=0 or ($y % 400)==0) );
}

sub Republican_to_Gregorian {
    my ($rep_date) = @_;
    state $months   = join '|', map { quotemeta } @month_names;
    state $intercal = join '|', map { quotemeta } @intercalary;
    state $re = qr{
      \A
        \s* (?:
                (?<ic> $intercal)
              | (?<day> \d+) \s+ (?<month> $months)
            )
        \s+ (?<year> \d+)
        \s*
      \z
    }msx;

    $rep_date =~ /$re/
        or die "Republican date not recognized: '$rep_date'";

    my $day1   = $+{ic}    ? $i_cal_nums{$+{ic}}    : $+{day};
    my $month1 = $+{month} ? $month_nums{$+{month}} : $i_cal_month;
    my $year1  = $+{year};

    my $days_since_epoch = ($year1-1) * 365 + ($month1-1) * 30 + ($day1-1);

    my $leap_days = grep { is_republican_leap_year($_) } 1 .. $year1-1;
    return $epoch->clone->add( days => ($days_since_epoch + $leap_days) );
}

sub Gregorian_to_Republican {
    my ($greg_date) = @_;

    my $days_since_epoch = $epoch->delta_days($greg_date)->in_units('days');
    die if $days_since_epoch < 0;
    my ( $year, $days ) = ( 1, $days_since_epoch );
    while (1) {
        my $year_length = 365 + ( is_republican_leap_year($year) ? 1 : 0 );
        last if $days < $year_length;
        $days -= $year_length;
        $year += 1;
    }
    my $day0   = $days % 30;
    my $month0 = ($days - $day0) / 30;

    my ( $day1, $month1 ) = ( $day0 + 1, $month0 + 1 );

    return $month1 == $i_cal_month
        ?       "$intercalary[$day0  ] $year"
        : "$day1 $month_names[$month0] $year";
}

while (<DATA>) {
    s{\s*\#.+\n?\z}{};
    /^(\d{4})-(\d{2})-(\d{2})\s+(\S.+?\S)\s*$/ or die;

    my $g = DateTime->new( year => $1, month => $2, day => $3 );
    my $r = $4;

    die if Republican_to_Gregorian($r) != $g
        or Gregorian_to_Republican($g) ne $r;

    die if Gregorian_to_Republican(Republican_to_Gregorian($r)) ne $r
        or Republican_to_Gregorian(Gregorian_to_Republican($g)) != $g;
}
say 'All tests successful.';

__DATA__
1792-09-22  1 Vendémiaire 1
1795-05-20  1 Prairial 3
1799-07-15  27 Messidor 7
1803-09-23  Fête de la Révolution 11
1805-12-31  10 Nivôse 14
1871-03-18  27 Ventôse 79
1944-08-25  7 Fructidor 152
2016-09-19  Fête du travail 224
1871-05-06  16 Floréal 79   # Paris Commune begins
1871-05-23  3 Prairial 79   # Paris Commune ends
1799-11-09  18 Brumaire 8   # Revolution ends by Napoléon coup
1804-12-02  11 Frimaire 13  # Republic   ends by Napoléon coronation
1794-10-30  9 Brumaire 3    # École Normale Supérieure established
1794-07-27  9 Thermidor 2   # Robespierre falls
1799-05-27  8 Prairial 7    # Fromental Halévy born
1792-09-22  1 Vendémiaire 1
1793-09-22  1 Vendémiaire 2
1794-09-22  1 Vendémiaire 3
1795-09-23  1 Vendémiaire 4
1796-09-22  1 Vendémiaire 5
1797-09-22  1 Vendémiaire 6
1798-09-22  1 Vendémiaire 7
1799-09-23  1 Vendémiaire 8
1800-09-23  1 Vendémiaire 9
1801-09-23  1 Vendémiaire 10
1802-09-23  1 Vendémiaire 11
1803-09-24  1 Vendémiaire 12
1804-09-23  1 Vendémiaire 13
1805-09-23  1 Vendémiaire 14
1806-09-23  1 Vendémiaire 15
1807-09-24  1 Vendémiaire 16
1808-09-23  1 Vendémiaire 17
1809-09-23  1 Vendémiaire 18
1810-09-23  1 Vendémiaire 19
1811-09-24  1 Vendémiaire 20
2015-09-23  1 Vendémiaire 224
2016-09-22  1 Vendémiaire 225
2017-09-22  1 Vendémiaire 226
