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

sub remove_element {
   my ($head_ref, $value) = @_;
   my $current = $$head_ref;
   my $prev    = undef;

   while ($current) {
      if ($current->{data} eq $value) {
         if ($prev) {
            $prev->{next} = $current->{next};
         } else {
            $$head_ref = $current->{next};
         }
         return 1;  # Element found and removed
      }
      $prev    = $current;
      $current = $current->{next};
   }
   return 0;  # Element not found
}

print "Original list:\n";
print_list($head);
remove_element(\$head, 'Node 2');
print "\nList after removing 'Node 2':\n";
print_list($head);
