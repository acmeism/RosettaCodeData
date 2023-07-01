# pbench.pl
use strict;
use warnings;

use Benchmark qw(cmpthese);
use Palindrome;

printf("%d, %d, %d, %d: %s\n",
       palindrome, palindrome_c, palindrome_r, palindrome_e, $_)
for
    qw/a aa ab abba aBbA abca abba1 1abba
    ingirumimusnocteetconsumimurigni/,
    'ab cc ba',	'ab ccb a';

printf "\n";

my $latin = "ingirumimusnocteetconsumimurigni";
cmpthese(100_000, {
    palindrome => sub { palindrome $latin },
    palindrome_c => sub { palindrome_c $latin },
    palindrome_r => sub { palindrome_r $latin },
    palindrome_e => sub { palindrome_e $latin },
});
