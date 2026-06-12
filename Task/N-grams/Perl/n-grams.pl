use v5.36;

sub n_gram ($n, $line) {
    my %N;
    map { $N{substr lc($line),$_,$n}++ } 0..length($line)-$n;
    %N
}

my %bi_grams = n_gram 2, 'Live and let live';
say qq|'$_' - $bi_grams{$_}| for sort keys %bi_grams;

say '';

my %tri_grams = n_gram 3, 'Live and let live';
say qq|'$_' - $tri_grams{$_}| for sort keys %tri_grams;
