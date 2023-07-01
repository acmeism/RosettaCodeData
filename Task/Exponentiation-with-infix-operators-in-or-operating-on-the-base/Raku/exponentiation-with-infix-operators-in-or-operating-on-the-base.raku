sub infix:<↑> is looser(&prefix:<->) { $^a ** $^b }
sub infix:<∧> is looser(&infix:<->)  { $^a ** $^b }

for
   ('Default precedence: infix exponentiation is tighter (higher) precedence than unary negation.',
     '1 + -$x**$p',   {1 + -$^a**$^b},   '1 + (-$x)**$p', {1 + (-$^a)**$^b},  '1 + (-($x)**$p)', {1 + (-($^a)**$^b)},
     '(1 + -$x)**$p', {(1 + -$^a)**$^b}, '1 + -($x**$p)', {1 + -($^a**$^b)}),

   ("\nEasily modified: custom loose infix exponentiation is looser (lower) precedence than unary negation.",
     '1 + -$x↑$p ',   {1 + -$^a↑$^b},    '1 + (-$x)↑$p ', {1 + (-$^a)↑$^b},   '1 + (-($x)↑$p) ', {1 + (-($^a)↑$^b)},
     '(1 + -$x)↑$p ', {(1 + -$^a)↑$^b},  '1 + -($x↑$p) ', {1 + -($^a↑$^b)}),

   ("\nEven more so: custom looser infix exponentiation is looser (lower) precedence than infix subtraction.",
     '1 + -$x∧$p ',   {1 + -$^a∧$^b},    '1 + (-$x)∧$p ', {1 + (-$^a)∧$^b},   '1 + (-($x)∧$p) ', {1 + (-($^a)∧$^b)},
     '(1 + -$x)∧$p ', {(1 + -$^a)∧$^b},  '1 + -($x∧$p) ', {1 + -($^a∧$^b)})
-> $case {
    my ($title, @operations) = $case<>;
    say $title;
    for -5, 5 X 2, 3 -> ($x, $p) {
        printf "x = %2d  p = %d", $x, $p;
        for @operations -> $label, &code { print " │ $label = " ~ $x.&code($p).fmt('%4d') }
        say ''
    }
}
