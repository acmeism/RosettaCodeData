use strict;
use warnings; # in homage to IBM card sorters :)

my $data = <<END;
Priority    Task
  3        Clear drains
  4        Feed cat
  5        Make tea
  1        Solve RC tasks
  2        Tax return
  4        Feed dog
END

insert( $1, $2 ) while $data =~ /(\d+)\h+(.*)/g; # insert all data

while( my $item = top_item_removal() ) # get in priority order
  {
  print "$item\n";
  }

######################################################################

my @bins; # priorities limited to small (<1e6 maybe?) non-negative integers

sub insert { push @{ $bins[shift] }, pop }        # O(1)

sub top_item_removal                              # O(1) (sort of, maybe?)
  {
  delete $bins[-1] while @bins and @{ $bins[-1] // [] } == 0;
  shift @{ $bins[-1] // [] };
  }
