# 20210316 Perl programming solution

use strict;
use warnings;
use Time::Piece;
use IO::Socket::INET;
use HTTP::Tiny;
use feature 'say';

my $needle = shift @ARGV // '';
my @haystack = ();
my $page = '';

# 10 days before today
my $begin =  Time::Piece->new - 10 * Time::Piece::ONE_DAY;
say "         Executed at: ", Time::Piece->new;
say "Begin searching from: $begin";

for (my $date = $begin ; Time::Piece->new > $date ; $date += Time::Piece::ONE_DAY) {
   $page .= HTTP::Tiny->new()->get( 'http://tclers.tk/conferences/tcl/'.$date->strftime('%Y-%m-%d').'.tcl')->{content};
}

# process pages
my @lines = split /\n/, $page;
for (@lines) { push @haystack, $_ if substr($_, 0, 13) =~ m/^m \d\d\d\d-\d\d-\d\dT/ }

# print the first and last line of the haystack
say "First and last lines of the haystack:";
say $haystack[0] and say $haystack[-1];

say "Needle: ", $needle;
say  '-' x 79;

# find and print needle lines
for (@haystack) { say $_ if (index($_, $needle) != -1) }
