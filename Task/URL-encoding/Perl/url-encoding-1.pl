sub urlencode {
    my $s = shift;
    $s =~ s/([^-A-Za-z0-9_.!~*'() ])/sprintf("%%%02X", ord($1))/eg;
    $s =~ tr/ /+/;
    return $s;
}

print urlencode('http://foo bar/')."\n";
