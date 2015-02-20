my %irregulars = <1 st 2 nd 3 rd>, (11..13 X=> 'th');

sub nth ($n) { $n ~ ( %irregulars{$n % 100} // %irregulars{$n % 10} // 'th' ) }

say .list».&nth for [^26], [250..265], [1000..1025];
