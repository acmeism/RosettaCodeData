sub is-narcissistic(Int $n) { $n == [+] $n.comb »**» $n.chars }

for 0 .. * {
    if .&is-narcissistic {
	.say;
	last if ++state$ >= 25;
    }
}
