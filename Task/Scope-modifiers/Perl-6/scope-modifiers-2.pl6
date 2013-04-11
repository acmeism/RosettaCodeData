sub a {
    my $*dyn = 'a';
    c();
}
sub b {
    my $*dyn = 'b';
    c();
}
sub c {
    say $*dyn;
}
a();  # says a
b();  # says b
