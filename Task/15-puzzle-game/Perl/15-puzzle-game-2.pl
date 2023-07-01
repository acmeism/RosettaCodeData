use strict;
use warnings;

use List::Util qw(shuffle first);
my @tbl = ([1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]);
my $e = [3,3];
for (1..$ARGV[0]||1000) {
  my $new = (shuffle &ad($e))[0];
  $tbl[$e->[0]][$e->[1]] = $tbl[$new->[0]][$new->[1]];
  $tbl[$new->[0]]->[$new->[1]] = 16;
  $e = [$new->[0],$new->[1]];
}
while(1){
  print +(join ' ',map{$_==16?'  ':sprintf '%02s',$_}@{$tbl[$_]}),"\n" for 0..3;
  my $m = <STDIN>;
  chomp $m;
  die "Enter a number to move!" unless $m;
  if ($m > 15){
	warn "$m not in the board! Enter a tile from 1 to 15\n";
	next;
  }
  my $tile=first{$tbl[$$_[0]]->[$$_[1]]==$m}map{[$_,0],[$_,1],[$_,2],[$_,3]}0..3;
  my $new=first{$tbl[$$_[0]]->[$$_[1]]==16}&ad(grep{$tbl[$$_[0]]->[$$_[1]]==$m}
          map {[$_,0],[$_,1],[$_,2],[$_,3]}0..3);
  if ($new){$tbl[$$new[0]][$$new[1]]=$m;$tbl[$$tile[0]][$$tile[1]]=16;}
  system ($^O eq 'MSWin32' ? 'cls' : 'clear');
}
sub ad{
      my $e = shift; grep {$_->[0]<4 && $_->[1]<4 && $_->[0]>-1 && $_->[1]>-1}
      [$$e[0]-1,$$e[1]],[$$e[0]+1,$$e[1]],[$$e[0],$$e[1]-1],[$$e[0],$$e[1]+1]
}
