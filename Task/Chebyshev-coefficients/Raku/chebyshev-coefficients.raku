sub chebft ( Code $func, Real \a, Real \b, Int \n ) {

    my \bma = ½ × (b - a);
    my \bpa = ½ × (b + a);

    my @pi-n = ( ^n »+» ½ ) »×» (π/n);
    my @f    = ( @pi-n».cos »×» bma »+» bpa )».&$func;
    my @sums = (^n).map: { [+] @f »×« ( @pi-n »×» $_ )».cos };

    @sums »×» (2/n)
}

say chebft(&cos, 0, 1, 10)».fmt: '%+13.7e';
