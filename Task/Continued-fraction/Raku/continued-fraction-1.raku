sub continued-fraction(:@a, :@b, Int :$n = 100)
{
    my $x = @a[$n - 1];
    $x = @a[$_ - 1] + @b[$_] / $x for reverse 1 ..^ $n;
    $x;
}

printf "√2 ≈%.9f\n", continued-fraction(:a(1, |(2 xx *)), :b(Nil, |(1 xx *)));
printf "e  ≈%.9f\n", continued-fraction(:a(2, |(1 .. *)), :b(Nil, 1, |(1 .. *)));
printf "π  ≈%.9f\n", continued-fraction(:a(3, |(6 xx *)), :b(Nil, |((1, 3, 5 ... *) X** 2)));
