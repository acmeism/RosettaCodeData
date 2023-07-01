use v6;

sub power-path ($n ) {
    state @unused_nodes = (2,);
    state @power-tree = (False,0,1);

    until @power-tree[$n].defined {
        my $node = @unused_nodes.shift;

        for  $node X+ power-path($node).pick(*) {
            next if @power-tree[$_].defined;
            @unused_nodes.push($_);
            @power-tree[$_]= $node;
        }
    }

    ( $n, { @power-tree[$_] } ...^ 0 ).reverse;
}

multi power ( $, 0 ) { 1 };
multi power ( $n, $exponent ) {
    state  %p;
    my     %r =  %p{$n}  // ( 0 => 1, 1 => $n ) ;

    for power-path( $exponent ).rotor( 2 => -1 ) -> ( $p, $c ) {
        %r{ $c } = %r{ $p } * %r{ $c - $p }
    }

    %p{$n} := %r ;
    %r{ $exponent }
}

say 'Power paths: ',      pairs map *.&power-path,    ^18;
say '2 ** key = value: ', pairs map { 2.&power($_) }, ^18;

say 'Path for 191: ', power-path 191;
say '3 ** 191 = ',    power   3, 191;
say 'Path for 81: ',  power-path  81;
say '1.1 ** 81 = ',   power 1.1,  81;
