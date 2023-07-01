use strict;
use warnings;
use feature 'bitwise';

my $size = shift // 8;

sub rotate
  {
  local $_ = shift;
  my $ans = '';
  $ans .= "\n" while s/.$/$ans .= $&; ''/gem;
  $ans;
  }

sub topattern
  {
  local $_ = shift;
  s/.+/ $& . ' ' x ($size - length $&)/ge;
  s/^\s+|\s+\z//g;
  [ tr/ \nA-Z/.. /r, lc tr/ \n/\0/r, substr $_, 0, 1 ]; # pattern, xor-update
  }

my %all;
@all{ " FF\nFF \n F \n", "IIIII\n", "LLLL\nL   \n", "NNN \n  NN\n",
  "PPP\nPP \n", "TTT\n T \n T \n", "UUU\nU U\n", "VVV\nV  \nV  \n",
  "WW \n WW\n  W\n", " X \nXXX\n X \n", "YYYY\n Y  \n", "ZZ \n Z \n ZZ\n",
  } = ();
@all{map rotate($_), keys %all} = () for 1 .. 3;  # all four rotations
@all{map s/.+/reverse $&/ger, keys %all} = ();    # mirror
my @all = map topattern($_), keys %all;
my $grid = ( ' ' x $size . "\n" ) x $size;
my %used;
find( $grid );

# looks for the first open space
sub find
  {
  my $grid = shift;
  %used >= 12 and exit not print $grid;
  for ( grep ! $used{ $_->[2] }, @all )
    {
    my ($pattern, $pentomino, $letter) = @$_;
    local $used{$letter} = 1;
    $grid =~ /^[^ ]*\K$pattern/s and find( $grid ^. "\0" x $-[0] . $pentomino );
    }
  }
