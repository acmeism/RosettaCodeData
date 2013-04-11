sub ev (Str $s --> Num) {

    grammar expr {
        token TOP { ^ <sum> $ }
        token sum { <product> (('+' || '-') <product>)* }
        token product { <factor> (('*' || '/') <factor>)* }
        token factor { <unary_minus>? [ <parens> || <literal> ] }
        token unary_minus { '-' }
        token parens { '(' <sum> ')' }
        token literal { \d+ ['.' \d+]? || '.' \d+ }
    }

    my sub minus ($b) { $b ?? -1 !! +1 }

    my sub sum ($x) {
        [+] product($x<product>), map
            { minus($^y[0] eq '-') * product $^y<product> },
            |($x[0] or [])
    }

    my sub product ($x) {
        [*] factor($x<factor>), map
            { factor($^y<factor>) ** minus($^y[0] eq '/') },
            |($x[0] or [])
    }

    my sub factor ($x) {
        minus($x<unary_minus>) * ($x<parens>
          ?? sum $x<parens><sum>
          !! $x<literal>)
    }

    expr.parse([~] split /\s+/, $s);
    $/ or fail 'No parse.';
    sum $/<sum>;

}
