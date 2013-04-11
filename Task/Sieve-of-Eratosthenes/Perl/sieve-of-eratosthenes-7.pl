sub erat {
    my $p = shift;
    return $p, $p**2 > $_[$#_] ? @_ : erat(grep $_%$p, @_)
}

print join ', ' => erat 2..100000;
