my @c = <_ #>;
my @array = '_###_##_#_#_#_#__#__'.comb »eq» '#';

repeat until @array eqv my @prev {
    say @c[@prev = @array].join;
    @array = ((@array Z+ @array.rotate(1)) Z+ @array.rotate(-1)) X== 2;
}
