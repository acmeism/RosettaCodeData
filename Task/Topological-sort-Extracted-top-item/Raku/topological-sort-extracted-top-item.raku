sub top_topos ( %deps, *@top ) {
    my %ba;
    for %deps.kv -> $after, @befores {
        for @befores -> $before {
            %ba{$after}{$before} = 0 if $before ne $after;
            %ba{$before} //= {};
        }
    }

    if @top {
	my @want = @top;
	my %care;
	%care{@want} = 1 xx *;
	repeat while @want {
	    my @newwant;
	    for @want -> $before {
		if %ba{$before} {
		    for %ba{$before}.keys -> $after {
			if not %ba{$before}{$after} {
			    %ba{$before}{$after}++;
			    push @newwant, $after;
			}
		    }
		}
	    }
	    @want = @newwant;
	    %care{@want} = 1 xx *;
	}

	for %ba.keys -> $before {
	    %ba{$before}:delete unless %care{$before};
	}
    }

    my @levels;
    while %ba.grep( not *.value )».key -> @befores {
	push @levels, ~@befores.sort;
        %ba{@befores}:delete;
        for %ba.values { .{@befores}:delete }
    }
    if @top {
	say "For top-level-modules: ", @top;
	say "  $_" for @levels;
    }
    else {
	say "Top levels are: @levels[*-1]";
    }

    say "Cycle found! {%ba.keys.sort}" if %ba;
    say '';
}

my %deps =
    top1  =>  <des1 ip1 ip2>,
    top2  =>  <des1 ip2 ip3>,
    ip1   =>  <extra1 ip1a ipcommon>,
    ip2   =>  <ip2a ip2b ip2c ipcommon>,
    des1  =>  <des1a des1b des1c>,
    des1a =>  <des1a1 des1a2>,
    des1c =>  <des1c1 extra1>;

top_topos(%deps);
top_topos(%deps, 'top1');
top_topos(%deps, 'top2');
top_topos(%deps, 'ip1');
top_topos(%deps, 'top1', 'top2');
