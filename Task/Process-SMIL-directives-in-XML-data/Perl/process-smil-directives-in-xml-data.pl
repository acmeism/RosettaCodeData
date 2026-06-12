# 20201101 added Perl programming solution

use 5.014; # for s///r;
use strict;
use warnings;

BEGIN {
   package Animatee;
   use Moo;
   has [qw(todo begin dur from to)] => ( is => 'rw');
   $INC{"Animatee.pm"} = 1;
}

use Animatee;
use XML::Twig;
use List::AllUtils 'pairwise';

my $smil = <<'DATA';
<?xml version="1.0" ?> <smil><X3D><Scene><Viewpoint position="0 0 8" orientation="0 0 1 0" /><PointLight color="1 1 1" location="0 2 0" /><Shape><Box size="2 1 2"><animate attributeName="size" from="2 1 2" to="1 2 1" begin="0s" dur="10s" /></Box><Appearance><Material diffuseColor="0.0 0.6 1.0"><animate attributeName="diffuseColor" from="0.0 0.6 1.0" to="1.0 0.4 0.0" begin="0s" dur="10s" /></Material></Appearance></Shape></Scene></X3D></smil>
DATA

my %Parents;

my $x = XML::Twig->new->parse($smil);

for my $node ($x->findnodes("//animate"))  {

   my $y = $node->parent;
   exists($Parents{$y}) ? (die) : ($Parents{my $k = $y->getName} = Animatee->new);
   for my $animatee ($y->getChildNodes)  {
      my %h = %{$animatee->atts};
      $Parents{$k}->todo($h{attributeName});
      $Parents{$k}->from([ split(/\s+/,$h{from}) ]);
      $Parents{$k}->to([ split(/\s+/,$h{to}) ]);
      $Parents{$k}->begin( $h{begin} =~ m/\d+/g);
      $Parents{$k}->dur  ( $h{dur}   =~ m/\d+/g);
   }
}

my $z =  XML::Twig->new->parse($smil =~ s/\<\/?smil\>//gr) or die;

for my $t ( 0, 2, 4 ) {
   my $clone = $z;
   while ( my( $k,$v ) = each %Parents) {
      my @incre = pairwise { ($a-$b)/$v->dur } @{$v->to}, @{$v->from};
      for my $f ($clone->findnodes("//$k")) {
         my $c = join (' ', pairwise { $a+$b*$t } @{$v->from}, @incre);
         $f->set_att($v->todo,$c);
      }
      for my $f ($clone->findnodes("//animate")) {
         $f->delete
      }
   }
   print "when t = $t\n";
   print $clone->sprint,"\n";
}
