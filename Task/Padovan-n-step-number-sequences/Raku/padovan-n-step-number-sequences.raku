say 'Padovan N-step sequences; first 25 terms:';

for 2..8 -> \N {
    my @n-step = 1, 1, 1, { state $n = 2; @n-step[ ($n - N .. $n++ - 1).grep: * >= 0 ].sum } … *;
    put "N = {N} |" ~ @n-step[^25]».fmt: "%5d";
}
