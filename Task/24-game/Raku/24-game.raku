use MONKEY-SEE-NO-EVAL;

say "Here are your digits: ",
constant @digits = (1..9).roll(4)».Str;

grammar Exp24 {
    token TOP { ^ <exp> $ { fail unless EVAL($/) == 24 } }
    rule exp { <term>+ % <op> }
    rule term { '(' <exp> ')' | <@digits> }
    token op { < + - * / > }
}

while my $exp = prompt "\n24? " {
    if try Exp24.parse: $exp {
        say "You win :)";
        last;
    } else {
        say (
            'Sorry.  Try again.' xx 20,
            'Try harder.' xx 5,
            'Nope.  Not even close.' xx 2,
            'Are you five or something?',
            'Come on, you can do better than that.'
        ).flat.pick
    }
}
