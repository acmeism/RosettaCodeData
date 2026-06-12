use Lingua::EN::Numbers;

my @factorial = 1, |[\*] 1..*;
my @Erdős = ^Inf .grep: { .is-prime and none($_ «-« @factorial[^(@factorial.first: * > $_, :k)]).is-prime }

put 'Erdős primes < 2500:';
put @Erdős[^(@Erdős.first: * > 2500, :k)]».&comma;
put "\nThe 7,875th Erdős prime is: " ~ @Erdős[7874].&comma;
