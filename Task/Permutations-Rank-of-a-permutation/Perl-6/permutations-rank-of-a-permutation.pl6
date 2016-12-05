use v6;

sub rank2inv ( $rank, $n = * ) {
    $rank.polymod( 1 ..^ $n );
}

sub inv2rank ( @inv ) {
    [+] @inv Z* [\*] 1, 1, * + 1 ... *
}

sub inv2perm ( @inv, @items is copy = ^@inv.elems ) {
    my @perm;
    for @inv.reverse -> $i {
        @perm.append: @items.splice: $i, 1;
    }
    @perm;
}

sub perm2inv ( @perm ) {     #not in linear time
    (
        { @perm[++$ .. *].grep( * < $^cur ).elems } for @perm;
    ).reverse;
}

for ^6 {
    my @row.push: $^rank;
    for ( *.&rank2inv(3) , &inv2perm, &perm2inv, &inv2rank )  -> &code {
        @row.push: code( @row[*-1] );
    }
    say @row;
}

my $perms =  4;      #100;
my $n     = 12;      #144;

say 'Via BigInt rank';
for ( ( ^([*] 1 .. $n) ).pick($perms) ) {
    say $^rank.&rank2inv($n).&inv2perm;
};

say 'Via inversion vectors';
for ( { my $i=0;  inv2perm (^++$i).roll xx $n } ... *  ).unique( with => &[eqv] ).[^$perms] {
    .say;
};

say 'Via Perl 6 method pick';
for ( { [(^$n).pick(*)] } ... * ).unique( with => &[eqv] ).head($perms) {
    .say
};
