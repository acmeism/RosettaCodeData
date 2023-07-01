#!/usr/bin/perl

use strict;
use warnings;

my @rows;
my $row = -1;
my $width = 0;
my $color = 0;
our $bg = 'e0ffe0';

parseoutline( do { local $/; <DATA> =~ s/\t/  /gr } );

print "<table border=1 cellspacing=0>\n";
for ( @rows )
  {
  my $start = 0;
  print "  <tr>\n";
  for ( @$_ ) # columns
    {
    my ($data, $col, $span, $bg) = @$_;
    print "    <td></td>\n" x ( $col - $start ),
      "    <td colspan=$span align=center bgcolor=#$bg> $data </td>\n";
    $start = $col + $span;
    }
  print "    <td></td>\n" x ( $width - $start ), "  </tr>\n";
  }
print "</table>\n";

sub parseoutline
  {
  ++$row;
  while( $_[0] =~ /^( *)(.*)\n((?:\1 .*\n)*)/gm )
    {
    my ($head, $body, $col) = ($2, $3, $width);
    $row == 1 and local $bg = qw( ffffe0 ffe0e0 )[ $color ^= 1];
    if( length $body ) { parseoutline( $body ) } else { ++$width }
    push @{ $rows[$row] }, [ $head, $col, $width - $col, $bg ];
    }
  --$row;
  }

__DATA__
Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.
