use v6;   # require Perl 6

my $bloop = -123;

if MY::{'$bloop'}.defined and CORE::{'&abs'}.defined { say abs $bloop }

my @ints = ($_ when Int for PROCESS::.values);
say "Number of PROCESS vars of type Int: ", +@ints;
say "PROCESS vars of type Int add up to ", [+] @ints;
