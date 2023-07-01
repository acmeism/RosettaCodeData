sub divmod ($v, $r) { $v div $r, $v mod $r }
my %chr = (flat 0..9, 'A'..'Z', <* @ #>) Z=> 0..*;

sub cuisp-check ($cuisp where *.chars == 9) {
    my ($code, $chk) = $cuisp.comb(8);
    my $sum = [+] $code.comb.kv.map: { [+] (($^k % 2 + 1) * %chr{$^v}).&divmod(10) };
    so (10 - $sum mod 10) mod 10 eq $chk;
}

# TESTING
say "$_: ", $_.&cuisp-check for <
037833100
17275R102
38259P508
594918104
68389X106
68389X105
>
