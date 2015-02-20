use strict;
use warnings;
use GD;

my @fword = ( undef, 1, 0 );

sub fword {
	my $n = shift;
	return $fword[$n] if $n<3;
	return $fword[$n] //= fword($n-1).fword($n-2);
}

my $size = 3000;
my $im = new GD::Image($size,$size);
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);
$im->transparent($white);
$im->interlaced('true');

my @pos   = (0,0);
my @dir   = (0,5);
my @steps = split //, fword 23;
my $i     = 1;
for( @steps ) {
	my @next = ( $pos[0]+$dir[0], $pos[1]+$dir[1] );
	$im->line( @pos, @next, $black );
	@dir = (  $dir[1], -$dir[0] ) if 0==$_ && 1==$i%2; # odd
	@dir = ( -$dir[1],  $dir[0] ) if 0==$_ && 0==$i%2; # even
	$i++;
	@pos = @next;
}

open my $out, ">", "fword.png" or die "Cannot open output file.\n";
binmode $out;
print $out $im->png;
close $out;
