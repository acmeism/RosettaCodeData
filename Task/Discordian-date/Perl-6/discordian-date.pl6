my @seasons = < Chaos Discord Confusion Bureaucracy >, 'The Aftermath';
my @days = < Sweetmorn Boomtime Pungenday Prickle-Prickle >, 'Setting Orange';
sub ordinal ( Int $n ) { $n ~ ( $n % 100 == 11|12|13
    ?? 'th' !! < th st nd rd th th th th th th >[$n % 10] ) }

sub ddate ( Str $ymd ) {
    my $d = DateTime.new: "{$ymd}T00:00:00Z" or die;

    my $yold = 'in the YOLD ' ~ $d.year + 1166;

    my $day_of_year0 = $d.day-of-year - 1;

    if $d.is-leap-year {
        return "St. Tib's Day, $yold" if $d.month == 2 and $d.day == 29;
        $day_of_year0-- if $day_of_year0 >= 60; # Compensate for St. Tib's Day
    }

    my $weekday    = @days[    $day_of_year0 mod  5     ];
    my $season     = @seasons[ $day_of_year0 div 73     ];
    my $season_day = ordinal(  $day_of_year0 mod 73 + 1 );

    return "$weekday, the $season_day day of $season $yold";
}

say "$_ is {.&ddate}" for < 2010-07-22 2012-02-28 2012-02-29 2012-03-01 >;
