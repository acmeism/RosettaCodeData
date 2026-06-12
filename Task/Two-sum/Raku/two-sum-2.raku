sub two-sum-lr (@a, $sum) {
  # (((^@a X ^@a) Z=> (@a X+ @a)).grep($sum == *.value)>>.keys.map:{ .split(' ').sort.join(' ')}).unique
    (
     (
      (^@a X ^@a) Z=> (@a X+ @a)
     ).grep($sum == *.value)>>.keys
     .map:{ .split(' ').sort.join(' ')}
    ).unique
}

sub two-sum-rl (@a, $sum) {
  # unique map {.split(' ').sort.join(' ')}, keys %(grep {.value == $sum}, ((^@a X ^@a) Z=> (@a X+ @a)))
    unique
    map {.split(' ').sort.join(' ')},
    keys %(
     grep {.value == $sum}, (
      (^@a X ^@a) Z=> (@a X+ @a)
     )
    )
}

my @a = <0 2 11 19 90>;
for 21, 25 {
    say two-sum-rl(@a, $_);
    say two-sum-lr(@a, $_);
}
