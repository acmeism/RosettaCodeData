# 20240913 Perl programming solution

use strict;
use warnings;

my %node3 = ( data => 'Node 3', next => undef );
my %node2 = ( data => 'Node 2', next => \%node3 );
my %node1 = ( data => 'Node 1', next => \%node2 );
my $head  = \%node1;

sub print_list {
   my ($head_ref) = @_;
   my $current = $head_ref;
   while ($current) {
      print $current->{data}, " -> ";
      $current = $current->{next};
   }
   print "undef\n";
}

sub reverse_list {
   my ($head_ref) = @_;
   my ($prev, $current, $next) = (undef, $$head_ref);
   while ($current) {
      $next = $current->{next};
      $current->{next} = $prev;
      ($prev, $current) = ($current, $next);
   }
   $$head_ref = $prev;
}

print "Original list:\n";
print_list($head);
reverse_list(\$head);
print "\nList after reversal:\n";
print_list($head);
