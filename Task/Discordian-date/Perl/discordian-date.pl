use 5.010;
use strict;
use warnings;
use Time::Piece ();

my @seasons = (qw< Chaos Discord Confusion Bureaucracy >, 'The Aftermath');
my @week_days = (qw< Sweetmorn Boomtime Pungenday Prickle-Prickle >, 'Setting Orange');

sub ordinal {
	my ($n) = @_;
	return $n . "th" if int($n/10) == 1;
	return $n . ((qw< th st nd rd th th th th th th>)[$n % 10]);
}

sub ddate {
	my $d = Time::Piece->strptime( $_[0], '%Y-%m-%d' );
	my $yold = 'in the YOLD ' . ($d->year + 1166);

	my $day_of_year0 = $d->day_of_year;

	if( $d->is_leap_year ) {
		return "St. Tib's Day, $yold" if $d->mon == 2 and $d->mday == 29;
		$day_of_year0-- if $day_of_year0 >= 60; # Compensate for St. Tib's Day
	}

	my $weekday = $week_days[ $day_of_year0 % @week_days ];
	my $season = $seasons[ $day_of_year0 / 73 ];
	my $season_day = ordinal( $day_of_year0 % 73 + 1 );

	return "$weekday, the $season_day day of $season $yold";
}

say "$_ is " . ddate($_) for qw< 2010-07-22 2012-02-28 2012-02-29 2012-03-01 >;
