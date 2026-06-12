sub Klarner-Rado ($n) {
    my @klarner-rado = 1;
    my @next = x2, x3;

    loop {
        @klarner-rado.push: my $min = @next.min;
        @next[0] = x2 if @next[0] == $min;
        @next[1] = x3 if @next[1] == $min;
        last if +@klarner-rado > $n.max;
    }

    sub x2 { state $i = 0; @klarner-rado[$i++] × 2 + 1 }
    sub x3 { state $i = 0; @klarner-rado[$i++] × 3 + 1 }

    @klarner-rado[|$n]
}

use Lingua::EN::Numbers;

put "First 100 elements of Klarner-Rado sequence:";
put Klarner-Rado(^100).batch(10)».fmt("%3g").join: "\n";
put '';
put (($_».Int».&ordinal».tc »~» ' element: ').List Z~ |(List.new: (Klarner-Rado ($_ »-» 1))».&comma)
    given $(1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6)).join: "\n";
