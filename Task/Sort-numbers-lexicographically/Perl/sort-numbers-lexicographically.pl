printf("%4d: [%s]\n", $_, join ',', sort $_ > 0 ? 1..$_ : $_..1) for 13, 21, -22
