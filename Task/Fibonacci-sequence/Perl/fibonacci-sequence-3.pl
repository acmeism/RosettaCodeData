# Binary ladder, GMP if available, Pure Perl otherwise
use ntheory qw/lucasu/;
say lucasu(1, -1, 10000);

# Uses GMP internal method, so similar performance as above
use Math::GMP;
say Math::GMP::fibonacci(10000);

# All Perl
use Math::NumSeq::Fibonacci;
my $seq = Math::NumSeq::Fibonacci->new;
say $seq->ith(10000);

# All Perl
use Math::Big qw/fibonacci/;
say 0+fibonacci(10000);  # Force scalar context

# Perl, gives floating point *approximation*
use Math::Fibonacci qw/term/;
say term(10000);
