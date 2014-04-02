sub generate {
    my $n = shift;
    my $str = '[' x $n;
    substr($str, rand($n + $_), 0) = ']' for 1..$n;
    return $str;
}

sub balanced {
    shift =~ /^ (\[ (?1)* \])* $/x;
}

for (0..8) {
    my $input = generate($_);
    print balanced($input) ? " ok:" : "bad:", " '$input'\n";
}
