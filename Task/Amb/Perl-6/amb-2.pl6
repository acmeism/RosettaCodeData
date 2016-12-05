sub infix:<lf> ($a,$b) {
    next unless try $a.substr(*-1,1) eq $b.substr(0,1);
    "$a $b";
}

multi dethunk(Callable $x) { try take $x() }
multi dethunk(     Any $x) {     take $x   }

sub amb (*@c) { gather @c».&dethunk }

say first *, do
    amb(<the that a>, { die 'oops'}) Xlf
    amb('frog',{'elephant'},'thing') Xlf
    amb(<walked treaded grows>)      Xlf
    amb { die 'poison dart' },
        {'slowly'},
        {'quickly'},
        { die 'fire' };
