sub logic($a,$b) {
    say "$a && $b is ", $a && $b;     # short-circuiting
    say "$a || $b is ", $a || $b;     # short-circuiting
    say "$a ^^ $b is ", $a ^^ $b;
    say "!$a is ",     !$a;

    say "$a ?& $b is ", $a ?& $b;     # non-short-circuiting
    say "$a ?| $b is ", $a ?| $b;     # non-short-circuiting
    say "$a ?^ $b is ", $a ?^ $b;     # non-short-circuiting

    say "$a +& $b is ", $a +& $b;     # numeric bitwise
    say "$a +| $b is ", $a +| $b;     # numeric bitwise
    say "$a +^ $b is ", $a +^ $b;     # numeric bitwise

    say "$a ~& $b is ", $a ~& $b;     # buffer bitwise
    say "$a ~| $b is ", $a ~| $b;     # buffer bitwise
    say "$a ~^ $b is ", $a ~| $b;     # buffer bitwise

    say "$a & $b is ", $a & $b;       # junctional/autothreading
    say "$a | $b is ", $a | $b;       # junctional/autothreading
    say "$a ^ $b is ", $a ^ $b;       # junctional/autothreading

    say "$a and $b is ", ($a and $b); # loose short-circuiting
    say "$a or $b is ",  ($a or $b);  # loose short-circuiting
    say "$a xor $b is ", ($a xor $b);
    say "not $a is ",    (not $a);
}

logic(3,10);
