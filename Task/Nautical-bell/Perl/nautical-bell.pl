use utf8;
binmode STDOUT, ":utf8";
use DateTime;

$| = 1; # to prevent output buffering

my @watch = <Middle Morning Forenoon Afternoon Dog First>;
my @ordinal = <One Two Three Four Five Six Seven Eight>;

my $thishour;
my $thisminute = '';

while () {
    my $utc = DateTime->now( time_zone => 'UTC' );
    if ($utc->minute =~ /^(00|30)$/ and $utc->minute != $thisminute) {
        $thishour   = $utc->hour;
        $thisminute = $utc->minute;
        bell($thishour, $thisminute);
    }
    printf "%s%02d:%02d:%02d", "\r", $utc->hour, $utc->minute, $utc->second;
    sleep(1);
}

sub bell {
    my($hour, $minute) = @_;

    my $bells = (($hour % 4) * 2 + int $minute/30) || 8;
    printf "%s%02d:%02d%9s watch,%6s Bell%s Gone: \t", "\b" x 9, $hour, $minute,
       $watch[(int($hour/4) - (0==($minute + $hour % 4)) + 6) % 6],
       $ordinal[$bells - 1], $bells == 1 ? '' : 's';
    chime($bells);
}

sub chime {
    my($count) = shift;
    for (1..int($count/2)) {
        print "\a♫ "; sleep .25;
        print "\a";   sleep .75;
    }
    if ($count % 2) {
        print "\a♪";  sleep 1;
    }
    print "\n";
}
