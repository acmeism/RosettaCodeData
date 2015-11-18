sub quick_sort {
    return @_ if @_ < 2;
    my $p = splice @_, int rand @_, 1;
    quick_sort(grep $_ < $p, @_), $p, quick_sort(grep $_ >= $p, @_);
}

my @a = (4, 65, 2, -31, 0, 99, 83, 782, 1);
@a = quick_sort @a;
print "@a\n";
