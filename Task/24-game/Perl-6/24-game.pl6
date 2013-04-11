grammar Exp24 {
    token TOP { ^ <exp> $ }
    token exp { <term> [ <op> <term> ]* }
    token term { '(' <exp> ')' | \d }
    token op { '+' | '-' | '*' | '/' }
}

my @digits = roll 4, 1..9;  # to a gamer, that's a "4d9" roll
say "Here's your digits: {@digits}";

while my $exp = prompt "\n24-Exp? " {
    unless is-valid($exp, @digits) {
        say "Sorry, your expression is not valid!";
        next;
    }

    my $value = eval $exp;
    say "$exp = $value";
    if $value == 24 {
        say "You win!";
        last;
    }
    say "Sorry, your expression doesn't evaluate to 24!";
}

sub is-valid($exp, @digits) {
    unless ?Exp24.parse($exp) {
        say "Expression doesn't match rules!";
        return False;
    }

    unless $exp.comb(/\d/).sort.join == @digits.sort.join {
        say "Expression must contain digits {@digits} only!";
        return False;
    }

    return True;
}
