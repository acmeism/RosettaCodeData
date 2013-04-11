sub derange (@result, @avail) {
    if not @avail { @result.item }
    else {
	map {
	    derange([ @result, @avail[$_] ],
	      @avail[0 .. $_-1, $_+1 ..^ @avail ])
	}, grep { @avail[$_] != @result }, 0 .. @avail-1;
    }
}

constant factorial = 1, [\*] 1...*;

# choose k among n, i.e. n! / k! (n-k)!
sub choose ($n, $k) { factorial[$n] div factorial[$k] div factorial[$n - $k] }

sub sub-factorial ($n) {
    (state @)[$n] //=
	factorial[$n] - [+] gather for 1 .. $n -> $k {
	    take choose($n, $k) * sub-factorial($n - $k);
	}
}

say "Derangements for 4 elements:";
for derange([], 0 .. 3).kv -> $i, @d {
    say $i+1, ': ', @d;
}

say "\nCompare list length and calculated table";
say "$_\t{+derange([], ^$_)}\t{sub-factorial($_)}" for 0 .. 9;

say "\nNumber of derangements:";
say "$_:\t{sub-factorial($_)}" for 1 .. 20;
