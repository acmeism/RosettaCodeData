sub postfix:<!> (Int $n) { (constant f = 1, |[\*] 1..*)[$n] }

sub is-wilson-prime (Int $p where * > 1) { (($p - 1)! + 1) %% $p }

# Pre initialize factorial routine (not thread safe)
9000!;

# Testing
put '   p  prime?';
printf("%4d  %s\n", $_, .&is-wilson-prime) for 2, 3, 9, 15, 29, 37, 47, 57, 67, 77, 87, 97, 237, 409, 659;

my $wilsons = (2,3,*+2…*).hyper.grep: &is-wilson-prime;

put "\nFirst 120 primes:";
put $wilsons[^120].rotor(20)».fmt('%3d').join: "\n";

put "\n1000th through 1015th primes:";
put $wilsons[999..1014];
