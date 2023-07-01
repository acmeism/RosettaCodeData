my @watch = <Middle Morning Forenoon Afternoon Dog First>;
my @ordinal = <One Two Three Four Five Six Seven Eight>;

my $thishour;
my $thisminute = '';

loop {
    my $utc = DateTime.new(time);
    if $utc.minute ~~ any(0,30) and $utc.minute != $thisminute {
        $thishour   = $utc.hour;
        $thisminute = $utc.minute;
        bell($thishour, $thisminute);
    }
    printf "%s%02d:%02d:%02d", "\r", $utc.hour, $utc.minute, $utc.second;
    sleep(1);
}

sub bell ($hour, $minute) {

    my $bells = (($hour % 4) * 2 + $minute div 30) || 8;

    printf "%s%02d:%02d %9s watch, %6s Bell%s Gone: \t", "\b" x 9, $hour, $minute,
      @watch[($hour div 4 - !?($minute + $hour % 4) + 6) % 6],
      @ordinal[$bells - 1], $bells == 1 ?? '' !! 's';

    chime($bells);

    sub chime ($count) {
	for 1..$count div 2 {
		print "\a♫ ";
		sleep .25;
		print "\a";
		sleep .75;
	}
	if $count % 2 {
	     print "\a♪";
	     sleep 1;
        }
        print "\n";
    }
}
