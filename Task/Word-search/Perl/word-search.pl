use strict;
use warnings;
use feature <bitwise>;
use Path::Tiny;
use List::Util qw( shuffle );

my $size = 10;
my $s1 = $size + 1;
$_ = <<END;
.....R....
......O...
.......S..
........E.
T........T
.A........
..C.......
...O......
....D.....
.....E....
END

my @words = shuffle path('/usr/share/dict/words')->slurp =~ /^[a-z]{3,7}$/gm;
my @played;
my %used;

for my $word ( (@words) x 5 )
  {
  my ($pat, $start, $end, $mask, $nulls) = find( $word );
  defined $pat or next;
  $used{$word}++ and next; # only use words once
  $nulls //= '';
  my $expand = $word =~ s/\B/$nulls/gr;
  my $pos = $start;
  if( $start > $end )
    {
    $pos = $end;
    $expand = reverse $expand;
    }
  substr $_, $pos, length $mask,
    (substr( $_, $pos, length $mask ) &. ~. "$mask") |. "$expand";
  push @played, join ' ', $word, $start, $end;
  tr/.// > 0 or last;
  }

print "   0 1 2 3 4 5 6 7 8 9\n\n";
my $row = 0;
print s/(?<=.)(?=.)/ /gr =~ s/^/ $row++ . '  ' /gemr;
print "\nNumber of words: ", @played . "\n\n";
my @where = map
  {
  my ($word, $start, $end) = split;
  sprintf "%11s %s", $word, $start < $end
    ? "(@{[$start % $s1]},@{[int $start / $s1]})->" .
      "(@{[$end % $s1 - 1]},@{[int $end / $s1]})"
    : "(@{[$start % $s1 - 1]},@{[int $start / $s1]})->" .
      "(@{[$end % $s1]},@{[int $end / $s1]})";
  } sort @played;
print splice(@where, 0, 3), "\n" while @where;
tr/.// and die "incomplete";

sub find
  {
  my ($word) = @_;
  my $n = length $word;
  my $nm1 = $n - 1;
  my %pats;

  for my $space ( 0, $size - 1 .. $size + 1 )
    {
    my $nulls = "\0" x $space;
    my $mask = "\xff" . ($nulls . "\xff") x $nm1; # vert
    my $gap = qr/.{$space}/s;
    while( /(?=(.(?:$gap.){$nm1}))/g )
      {
      my $pat = ($1 &. $mask) =~ tr/\0//dr;
      $pat =~ tr/.// or next;
      my $pos = "$-[1] $+[1]";
      $word =~ /$pat/ or reverse($word) =~ /$pat/ or next;
      push @{ $pats{$pat} }, "$pos $mask $nulls";
      }
    }

  for my $key ( sort keys %pats )
    {
    if( $word =~ /^$key$/ )
      {
      my @all = @{ $pats{$key} };
      return $key, split ' ', $all[ rand @all ];
      }
    elsif( (reverse $word) =~ /^$key$/ )
      {
      my @all = @{ $pats{$key} };
      my @parts = split ' ', $all[ rand @all ];
      return $key, @parts[ 1, 0, 2, 3]
      }
    }

  return undef;
  }
