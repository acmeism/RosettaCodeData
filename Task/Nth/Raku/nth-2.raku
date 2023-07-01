my %irregulars = <1 ˢᵗ 2 ⁿᵈ 3 ʳᵈ>, (11..13 X=> 'ᵗʰ');

sub nth ($n) { $n ~ ( %irregulars{$n % 100} // %irregulars{$n % 10} // 'ᵗʰ' ) }

say .list».&nth for [^26], [250..265], [1000..1025];
