sub R($n, $p) { [+] ((rand < $p) xx $n).squish }

say 't= ', constant t = 100;

for .1, .3 ... .9 -> $p {
    say "p= $p, K(p)= {$p*(1-$p)}";
    for 10, 100, 1000 -> $n {
	printf "  R(%6d, p)= %f\n", $n, t R/ [+] R($n, $p)/$n xx t
    }
}
