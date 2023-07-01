test $# -gt 0 || set -- $((RANDOM % 32000))
for seed; do
	print Game $seed:

	# Shuffle deck.
	deck=({A,{2..9},T,J,Q,K}{C,D,H,S})
	for i in {52..1}; do
		((seed = (214013 * seed + 2531011) & 0x7fffffff))
		((j = (seed >> 16) % i + 1))
		t=$deck[$i]
		deck[$i]=$deck[$j]
		deck[$j]=$t
	done

	# Deal cards.
	print -n ' '
	for i in {52..1}; do
		print -n ' '$deck[$i]
		((i % 8 == 5)) && print -n $'\n '
	done
	print
done
