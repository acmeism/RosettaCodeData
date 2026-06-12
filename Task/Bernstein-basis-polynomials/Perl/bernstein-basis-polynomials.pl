# 20241001 Perl programming solution

use strict;
use warnings;

sub monomial_to_bernstein_degree2 {
   my ($a0, $a1, $a2) = @_;
   return ($a0, $a0 + (1/2) * $a1, $a0 + $a1 + $a2);
}

sub evaluate_bernstein_degree2 {
   my ($b0, $b1, $b2, $t) = @_;
   my $s = 1 - $t;
   my ($b01, $b12) = ( ($s * $b0) + ($t * $b1), ($s * $b1) + ($t * $b2) );
   return ($s * $b01) + ($t * $b12);
}

sub monomial_to_bernstein_degree3 {
   my ($a0, $a1, $a2, $a3) = @_;
   return ( $a0,
            $a0 + (1/3) * $a1,
            $a0 + (2/3) * $a1 + (1/3) * $a2,
            $a0 +  $a1  + $a2 + $a3 )
}

sub evaluate_bernstein_degree3 {
   my ($b0, $b1, $b2, $b3, $t) = @_;
   my $s = 1 - $t;
   my ($b01, $b12, $b23) = ( $s*$b0+$t*$b1, $s*$b1+$t*$b2, $s*$b2+$t*$b3 );
   my ($b012, $b123) = (($s * $b01) + ($t * $b12), ($s * $b12) + ($t * $b23));
   return ($s * $b012) + ($t * $b123);
}

sub bernstein_degree2_to_degree3 {
   my ($b0, $b1, $b2) = @_;
   return ( $b0, (1/3) * $b0 + (2/3) * $b1, (2/3) * $b1 + (1/3) * $b2, $b2 );
}

sub evaluate_monomial_degree2 {
   my ($a0, $a1, $a2, $t) = @_;
   return $a0 + ($t * ($a1 + ($t * $a2)));
}

sub evaluate_monomial_degree3 {
   my ($a0, $a1, $a2, $a3, $t) = @_;
   return  $a0 + ($t * ($a1 + ($t * ($a2 + ($t * $a3)))));
}

my @pmono2 = (1, 0, 0);
my @qmono2 = (1, 2, 3);
my @pbern2 = monomial_to_bernstein_degree2(@pmono2);
my @qbern2 = monomial_to_bernstein_degree2(@qmono2);

print "Subprogram (1) examples:\n";
print "mono (@pmono2)  --> bern (@pbern2)\n";
print "mono (@qmono2)  --> bern (@qbern2)\n";

print "Subprogram (2) examples:\n";
for my $x (0.25, 7.50) {
   print "p( ", "$x", " ) = ", evaluate_bernstein_degree2(@pbern2, $x),
         " ( mono: ", evaluate_monomial_degree2(@pmono2, $x), " )\n";
}
for my $x (0.25, 7.50) {
   print "q( ", "$x", " ) = ", evaluate_bernstein_degree2(@qbern2, $x),
         " ( mono: ", evaluate_monomial_degree2(@qmono2, $x), " )\n";
}

my @pmono3 = (1, 0, 0, 0);
my @qmono3 = (1, 2, 3, 0);
my @rmono3 = (1, 2, 3, 4);

my @pbern3 = monomial_to_bernstein_degree3(@pmono3);
my @qbern3 = monomial_to_bernstein_degree3(@qmono3);
my @rbern3 = monomial_to_bernstein_degree3(@rmono3);

print "Subprogram (3) examples:\n";
print "mono (@pmono3)  --> bern (@pbern3)\n";
print "mono (@qmono3)  --> bern (@qbern3)\n";
print "mono (@rmono3)  --> bern (@rbern3)\n";

print "Subprogram (4) examples:\n";
my @curves = ( ['p', \@pbern3, \@pmono3],
               ['q', \@qbern3, \@qmono3],
               ['r', \@rbern3, \@rmono3], );

foreach my $x (0.25, 7.50) {
   foreach my $curve (@curves) {
      my ($name, $bern_ref, $mono_ref) = @$curve;
      print "$name($x) = ", evaluate_bernstein_degree3(@$bern_ref, $x),
            " (mono: ", evaluate_monomial_degree3(@$mono_ref, $x), ")\n";
   }
}

print "Subprogram (5) examples:\n";
my @pbern3a = bernstein_degree2_to_degree3(@pbern2);
my @qbern3a = bernstein_degree2_to_degree3(@qbern2);

print "bern (@pbern2) --> bern (@pbern3a)\n";
print "bern (@qbern2) --> bern (@qbern3a)\n";
