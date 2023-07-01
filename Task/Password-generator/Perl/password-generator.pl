use strict;
use warnings;
use feature 'say';

use English;
use Const::Fast;
use Getopt::Long;
use Math::Random;

const my @lcs    => 'a' .. 'z';
const my @ucs    => 'A' .. 'Z';
const my @digits => 0 .. 9;
const my $others => q{!"#$%&'()*+,-./:;<=>?@[]^_{|}~};  # "

my $pwd_length  = 8;
my $num_pwds    = 6;
my $seed_phrase = 'TOO MANY SECRETS';

my %opts = (
'password_length=i' => \$pwd_length,
'num_passwords=i'   => \$num_pwds,
'seed_phrase=s'     => \$seed_phrase,
'help!'             => sub {command_line_help(); exit 0}
);
command_line_help() and exit 1 unless $num_pwds >= 1 and $pwd_length >= 4 and GetOptions(%opts);

random_set_seed_from_phrase($seed_phrase);
say gen_password() for 1 .. $num_pwds;

sub gen_password {
    my @generators = (\&random_lc, \&random_uc, \&random_digit, \&random_other);
    my @chars = map {$ARG->()} @generators;  # At least one char of each type.
    push @chars, $generators[random_uniform_integer(1, 0, 3)]->() for 1 .. $pwd_length - 4;
    join '', random_permutation(@chars);
}

sub random_lc    {    $lcs[ random_uniform_integer(1, 0, $#lcs)    ] }
sub random_uc    {    $ucs[ random_uniform_integer(1, 0, $#ucs)    ] }
sub random_digit { $digits[ random_uniform_integer(1, 0, $#digits) ] }
sub random_other { substr($others, random_uniform_integer(1, 0, length($others)-1), 1) }

sub command_line_help {
    say <<~END
       Usage: $PROGRAM_NAME
       [--password_length=<l> default: 8, minimum: 4]
       [--num_passwords=<n>   default: 6, minimum: 1]
       [--seed_phrase=<s>     default: TOO MANY SECRETS (optional)]
       [--help]
       END
}
