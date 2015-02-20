sub quick_sort {
    my @a = @_;
    return @a if @a < 2;
    my $p = splice @a, int rand @a, 1;
    quick_sort(grep $_ < $p, @a), $p, quick_sort(grep $_ >= $p, @a);
}

my @a = (4, 65, 2, -31, 0, 99, 83, 782, 1);
@a = quick_sort @a;
print "@a\n";
