sub Y { my $f = shift;
    sub {$f->(Y($f))->(@_)}
}
