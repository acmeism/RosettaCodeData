sub dsort {
        my ($m, $n) = @_;
        my %h;
        $h{$_}++ for @$n;
        map $h{$_}-- > 0 ? shift @$n : $_, @$m;
}

for (split "\n", <<"IN")
        the cat sat on the mat  | mat cat
        the cat sat on the mat  | cat mat
        A B C A B C A B C       | C A C A
        A B C A B D A B E       | E A D A
        A B                     | B
        A B                     | B A
        A B B A                 | B A
IN
{

        my ($a, $b) = map([split], split '\|');
        print "@$a | @$b -> @{[dsort($a, $b)]}\n";
}
