use utf8;

BEGIN {
    my $val;
    sub Δ () : lvalue {
        $val;
    }
}

Δ = 1;
Δ++;
print Δ, "\n";
