def select_while(s; cond):
  label $out | s | if cond then . else break $out end;

### Some primes
# 168 small primes
def small_primes:  [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
    101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
    211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
    307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397,
    401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
    503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
    601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
    701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
    809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
    907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997
  ];

### n-smooth numbers
def nSmooth($n; $size):
  small_primes[-1] as $maxn
  | if $n < 2 or $n > $maxn then "nSmooth: n must be in 2 .. \($maxn) inclusive" | error
    elif ($size < 1) then "nSmooth: size must be at least 1" | error
    elif any(small_primes[]; $n == .) | not then "nSmooth: n must be a prime number" | error
    else (small_primes|length) as $length
    | {ns: [1, (range(1; $size)|null)],
       i: 0,
       next: [] }
    | until(.done or .i == $length;
        if (small_primes[.i] > $n) then .done = true
        else .next += [small_primes[.i]]
	| .i += 1
	end )
    | .indices = [range(0; .next|length) | 0]
    | reduce range(1; $size) as $m (.;
        .ns[$m] = (.next | min)
        | reduce range(0; .indices|length) as $i (.;
            if (.ns[$m] == .next[$i])
            then .indices[$i] += 1
            | .next[$i] = small_primes[$i] * .ns[.indices[$i]]
            else .
	    end ))
    | .ns
    end;

def task:
  [select_while(small_primes[]; . <= 29)] as $smallPrimes
  | ($smallPrimes[]
    | "\nThe first 25 \(.)-smooth numbers are:",
       nSmooth(.; 25)),
       "",
    ($smallPrimes[1:][]
    | "\nThe 3,000th to 3,202nd \(.)-smooth numbers are:",
       nSmooth(.; 3002)[2999:] ),
       "",
    ( (503, 509, 521)
     |"\nThe 30,000th to 30,019th \(.)-smooth numbers are:",
      nSmooth(.; 30019)[29999:] ) ;

task
