my @month = <January February March April May June July August September October November December>;
my %month = flat (@month Z=> 1..12), (@month».substr(0,3) Z=> 1..12), 'Sept' => 9;

grammar US-DateTime {
    rule TOP { <month> <day>','? <year>','? <time> <tz> }

    token month {
	(\w+)'.'?  { make %month{$0} // die "Bad month name: $0" }
    }

    token day { (\d ** 1..2) { make +$0 } }

    token year { (\d ** 1..4) { make +$0 } }

    token time {
	(\d ** 1..2) ':' (\d ** 2) \h* ( :i <[ap]> \.? m | '' )
	{
	    my $h = $0 % 12;
	    my $m = $1;
	    $h += 12 if $2 and $2.substr(0,1).lc eq 'p';
	    make $h * 60 + $m;
	}
    }

    token tz {  # quick and dirty for this task
        [
        |        EDT  { make -4 }
        | [ EST| CDT] { make -5 }
        | [ CST| MDT] { make -6 }
        | [ MST| PDT] { make -7 }
        | [ PST|AKDT] { make -8 }
        | [AKST|HADT] { make -9 }
        |  HAST
        ]
    }
}

$/ = US-DateTime.parse('March 7 2009 7:30pm EST') or die "Can't parse date";

my $year     = $<year>.ast;
my $month    = $<month>.ast;
my $day      = $<day>.ast;
my $hour     = $<time>.ast div 60;
my $minute   = $<time>.ast mod 60;
my $timezone = $<tz>.ast * 3600;

my $dt = DateTime.new(:$year, :$month, :$day, :$hour, :$minute, :$timezone).in-timezone(0);

$dt = $dt.later(hours => 12);

say "12 hours later, UTC: $dt";
say "12 hours later, PDT: $dt.in-timezone(-7 * 3600)";
