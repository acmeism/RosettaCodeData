use v6;
# Using LWP::Simple from: git://github.com/cosimo/perl6-lwp-simple.git
use LWP::Simple;

print LWP::Simple.get("http://www.rosettacode.org");
