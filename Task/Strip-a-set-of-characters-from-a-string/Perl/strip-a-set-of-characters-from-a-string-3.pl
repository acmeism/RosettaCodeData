sub stripchars {
    my ($s, $chars) = @_;
    eval("\$s =~ tr/$chars//d;");
    return $s;
}
