sub f { $_[0] ? $_[0] * f($_[0]-1) : 1 }
sub catalan { f(2 * $_[0]) / f($_[0]) / f($_[0]+1) }

print "$_\t@{[ catalan($_) ]}\n" for 0 .. 20;
