my @states = <
    Alabama Alaska Arizona Arkansas California Colorado Connecticut Delaware
    Florida Georgia Hawaii Idaho Illinois Indiana Iowa Kansas Kentucky
    Louisiana Maine Maryland Massachusetts Michigan Minnesota Mississippi
    Missouri Montana Nebraska Nevada New_Hampshire New_Jersey New_Mexico
    New_York North_Carolina North_Dakota Ohio Oklahoma Oregon Pennsylvania
    Rhode_Island South_Carolina South_Dakota Tennessee Texas Utah Vermont
    Virginia Washington West_Virginia Wisconsin Wyoming
>;

say "50 states:";
.say for anastates @states;

say "\n54 states:";
.say for anastates @states, < New_Kory Wen_Kory York_New Kory_New New_Kory >;

sub anastates (*@states) {
    my @s = @states.uniq».subst('_', ' ');

    my @pairs = gather for ^@s -> $i {
	for $i ^..^ @s -> $j {
	    take [ @s[$i], @s[$j] ];
	}
    }

    my $equivs = hash @pairs.classify: *.lc.comb.sort.join.trim;

    gather for $equivs.values -> @c {
	for ^@c -> $i {
	    for $i ^..^ @c -> $j {
		my $set = set @c[$i].list, @c[$j].list;
		take $set.join(', ') if $set == 4;
	    }
	}
    }
}
