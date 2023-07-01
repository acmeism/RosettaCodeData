sub complement
{
    my $s = shift;

    $s =~ tr/01/10/;

    return $s;
}

my $str = '0';

for (0..6) {
    say $str;
    $str .= complement($str);
}
