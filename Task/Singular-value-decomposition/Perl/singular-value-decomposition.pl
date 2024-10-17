# 20240920 Perl programming solution

use strict;
use warnings;
use Math::GSL::Matrix;
use Math::GSL::Linalg qw/gsl_linalg_SV_decomp/;

my  $M         =   Math::GSL::Matrix->new(2, 2);
$M->set_elem(0,0,3)->set_elem(0,1,0)->set_elem(1,0,4)->set_elem(1,1,5);

my  $V         =   Math::GSL::Matrix->new(2, 2);
my ($S, $work) = ( Math::GSL::Vector->new(2), Math::GSL::Vector->new(2) );

gsl_linalg_SV_decomp($M->raw, $V->raw, $S->raw, $work->raw);

print "U factor:\n";
for my $i (0 .. $M->rows - 1) { print join(", ",$M->row($i)->as_list),"\n" }
print "singular values:\n";
print join(", ", map { sprintf("%.10g", $_) } $S->as_list), "\n";
print "Vt factor:\n";
for my $i (0 .. $V->rows - 1) { print join(", ",$V->row($i)->as_list),"\n" }
