sub binomial { [×] ($^n … 0) Z/ 1 .. $^p }

sub binomial-transform (*@seq) {
    @seq.keys.map: -> \n { sum (0..n).map: -> \k { binomial(n,k) × @seq[k] } }
}

sub inverse-binomial-transform (*@seq) {
    @seq.keys.map: -> \n { sum (0..n).map: -> \k { binomial(n,k) × @seq[k] × exp(n - k, -1) } }
}

sub si-binomial-transform (*@seq) { #self inverting
    @seq.keys.map: -> \n { sum (0..n).map: -> \k { binomial(n,k) × @seq[k] × exp(k, -1) } }
}

my $upto = 20;

for 'Catalan number',   (1, {[+] @_ Z× @_.reverse}…*),
    'Prime flip-flop',  (1..*).map({.is-prime ?? 1 !! 0}),
    'Fibonacci number', (0,1,*+*…*),
    'Padovan number',   (1,0,0, -> $c,$b,$ {$b+$c}…*)
  -> $name, @seq {
    say qq:to/BIN/;
    $name sequence:
    {@seq[^$upto]}
    Forward binomial transform:
    {binomial-transform(@seq)[^$upto]}
    Inverse binomial transform:
    {inverse-binomial-transform(@seq)[^$upto]}
    Round trip:
    {inverse-binomial-transform(binomial-transform(@seq))[^$upto]}
    Self inverting:
    {si-binomial-transform(@seq)[^$upto]}
    Re inverted:
    {si-binomial-transform(si-binomial-transform(@seq))[^$upto]}
    BIN
}
