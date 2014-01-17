# Iterative Fibonacci with bignum support.
# Multi-licensed under your choice of:
# 1. The GNU Free Documentation License (GFDL).
# 2. The MIT/X11 license.
# 3. The GNU General Publice License (GPL).
# 4. The Public Domain as understood by the CC-Zero public domain dedication.

use strict;
use warnings;

use Math::BigInt try => 'GMP';

sub fib_iter
{
    my ($n) = @_;

    my $this_fib = Math::BigInt->new(0);
    my $next_fib = Math::BigInt->new(1);

    my $pos = 0;

    while ($pos < $n)
    {
        ($this_fib, $next_fib) = ($next_fib, $this_fib+$next_fib);
    }
    continue
    {
        $pos++;
    }

    return $this_fib;
}
