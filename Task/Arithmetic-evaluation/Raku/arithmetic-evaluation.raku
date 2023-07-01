sub ev (Str $s --> Numeric) {

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
        [+] flat product($x<product>), map
            { minus($^y[0] eq '-') * product $^y<product> },
            |($x[0] or [])
    }

    my sub product ($x) {
        [*] flat factor($x<factor>), map
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

# Testing:

say ev '5';                                    #   5
say ev '1 + 2 - 3 * 4 / 5';                    #   0.6
say ev '1 + 5*3.4 - .5  -4 / -2 * (3+4) -6';   #  25.5
say ev '((11+15)*15)* 2 + (3) * -4 *1';        # 768
