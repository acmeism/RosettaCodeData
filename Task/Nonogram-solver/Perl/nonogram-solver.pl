use strict;
use warnings;

my $file = 'nonogram_problems.txt';
open my $fd, '<', $file or die "$! opening $file";

while(my $row = <$fd> )
  {
  $row =~ /\S/ or next;
  my $column = <$fd>;
  my @rpats = makepatterns($row);
  my @cpats = makepatterns($column);
  my @rows = ( '.' x @cpats ) x @rpats;
  for( my $prev = ''; $prev ne "@rows"; )
    {
    $prev = "@rows";
    try(\@rows, \@rpats);
    my @cols = map { join '', map { s/.//; $& } @rows } 0..$#cpats;
    try(\@cols, \@cpats);
    @rows = map { join '', map { s/.//; $& } @cols } 0..$#rpats;
    }
  print "\n", "@rows" =~ /\./ ? "Failed\n" : map { tr/01/.#/r, "\n" } @rows;
  }

sub try
  {
  my ($lines, $patterns) = @_;
  for my $i ( 0 .. $#$lines )
    {
    while( $lines->[$i] =~ /\./g )
      {
      for my $try ( 0, 1 )
        {
        $lines->[$i] =~ s/.\G/$try/r =~ $patterns->[$i] or
          $lines->[$i] =~ s// 1 - $try /e;
        }
      }
    }
  }

sub makepatterns {                         #    numbered to show the 'logical' order of operations
    map { qr/^$_$/                          # 7  convert strings to regex
        } map {  '[0.]*'                    # 6a prepend static pattern
               . join('[0.]+',              # 5  interleave with static pattern
                       map { "[1.]{$_}"     # 4  require to match exactly 'n' times
                           } map { -64+ord  # 3  convert letter value to repetition count 'n'
                                 } split // # 2  for each letter in group
                     )
               . '[0.]*'                    # 6b append static pattern
              } split ' ', shift;           # 1  for each letter grouping
}
