use MONKEY-SEE-NO-EVAL;

sub MAIN ($x) {
    my @n = $x.comb(/<ident>/);
    my &fun = EVAL "-> {('\\' «~« @n).join(',')} \{ [{ (|@n,"so $x").join(',') }] \}";

    say (|@n,$x).join("\t");
    .join("\t").say for map &fun, flat map { .fmt("\%0{+@n}b").comb».Int».so }, 0 ..^ 2**@n;
    say '';
}
