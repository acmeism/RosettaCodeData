my %he-likes =
    abe  => < abi eve cath ivy jan dee fay bea hope gay >,
    bob  => < cath hope abi dee eve fay bea jan ivy gay >,
    col  => < hope eve abi dee bea fay ivy gay cath jan >,
    dan  => < ivy fay dee gay hope eve jan bea cath abi >,
    ed   => < jan dee bea cath fay eve abi ivy hope gay >,
    fred => < bea abi dee gay eve ivy cath jan hope fay >,
    gav  => < gay eve ivy bea cath abi dee hope jan fay >,
    hal  => < abi eve hope fay ivy cath jan bea gay dee >,
    ian  => < hope cath dee gay bea abi fay ivy jan eve >,
    jon  => < abi fay jan gay eve bea dee cath ivy hope >,
;

my %she-likes =
    abi  => < bob fred jon gav ian abe dan ed col hal >,
    bea  => < bob abe col fred gav dan ian ed jon hal >,
    cath => < fred bob ed gav hal col ian abe dan jon >,
    dee  => < fred jon col abe ian hal gav dan bob ed >,
    eve  => < jon hal fred dan abe gav col ed ian bob >,
    fay  => < bob abe ed ian jon dan fred gav col hal >,
    gay  => < jon gav hal fred bob abe col ed dan ian >,
    hope => < gav jon bob abe ian dan hal ed col fred >,
    ivy  => < ian col hal gav fred bob abe ed jon dan >,
    jan  => < ed hal gav abe bob jon col ian fred dan >,
;

my \guys = %he-likes.keys;
my \gals = %she-likes.keys;

my %fiancé;
my %fiancée;
my %proposed;

sub she-prefers ($her, $hottie) { .index($hottie) < .index(%fiancé{$her}) given ~%she-likes{$her} }
sub he-prefers  ($him, $hottie) { .index($hottie) < .index(%fiancée{$him}) given ~%he-likes{$him} }

match'em;
check-stability;

perturb'em;
check-stability;

sub match'em {                                          #'
    say 'Matchmaking:';
    while unmatched-guy() -> $guy {
        my $gal = preferred-choice($guy);
        %proposed{"$guy $gal"} = '❤';
        if not %fiancé{$gal} {
            engage($guy, $gal);
            say "\t$gal and $guy";
        }
        elsif she-prefers($gal, $guy) {
	    my $engaged-guy = %fiancé{$gal};
	    engage($guy, $gal);
	    %fiancée{$engaged-guy} = '';
	    say "\t$gal dumped $engaged-guy for $guy";
	}
    }
}

sub check-stability {
    my @instabilities = gather for guys X gals -> $m, $w {
	if he-prefers($m, $w) and she-prefers($w, $m) {
	    take "\t$w prefers $m to %fiancé{$w} and $m prefers $w to %fiancée{$m}";
	}
    }

    say 'Stablility:';
    if @instabilities {
	.say for @instabilities;
    }
    else {
        say "\t(all marriages stable)";
    }
}

sub unmatched-guy { guys.first: { not %fiancée{$_} } }

sub preferred-choice($guy) { %he-likes{$guy}.first: { not %proposed{"$guy $_" } } }

sub engage($guy, $gal) {
    %fiancé{$gal} = $guy;
    %fiancée{$guy} = $gal;
}

sub perturb'em {                                            #'
    say 'Perturb:';
    say "\tengage abi with fred and bea with jon";
    engage('fred', 'abi');
    engage('jon', 'bea');
}
