# Factorial
sub postfix:<!> (Int $n) { (constant f = 1, |[\×] 1..*)[$n] }

# Invisible times
sub infix:<⁢> is tighter(&infix:<**>) { $^a * $^b };

# Prime the iterator for thread safety
sink 11000!;

my @primes = ^1.1e4 .grep: *.is-prime;

say
'  n: Wilson primes
────────────────────';

.say for (1..40).hyper(:1batch).map: -> \𝒏 {
    sprintf "%3d: %s", 𝒏, @primes.grep( -> \𝒑 { (𝒑 ≥ 𝒏) && ((𝒏 - 1)!⁢(𝒑 - 𝒏)! - (-1) ** 𝒏) %% 𝒑² } ).Str
}
