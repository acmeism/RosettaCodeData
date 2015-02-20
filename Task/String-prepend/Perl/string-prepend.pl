my $str = 'bar';
substr $str, 0, 0, 'Foo';
print $str;
