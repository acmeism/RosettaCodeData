use Math::Complex;
my $cpl = Math::Complex->new(1,1);

print "package Math::Complex has 'make' method\n"
        if Math::Complex->can('make');

print "object \$cpl does not have 'explode' method\n"
        unless $cpl->can('explode');
