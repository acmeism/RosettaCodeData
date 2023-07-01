my @c = (1);
sub catalan {
        use bigint;
        $c[$_[0]] //= catalan($_[0]-1) * (4 * $_[0]-2) / ($_[0]+1)
}

# most of the time is spent displaying the long numbers, actually
print "$_\t", catalan($_), "\n" for 0 .. 10000;
