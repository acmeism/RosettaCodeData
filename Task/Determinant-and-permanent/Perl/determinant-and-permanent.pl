#!/usr/bin/perl
use strict;
use warnings;
use PDL;
use PDL::NiceSlice;

sub permanent{
	my $mat = shift;
	my $n = shift // $mat->dim(0);
	return undef if $mat->dim(0) != $mat->dim(1);
	return $mat(0,0) if $n == 1;
	my $sum = 0;
	--$n;
	my $m = $mat(1:,1:)->copy;
	for(my $i = 0; $i <= $n; ++$i){
		$sum += $mat($i,0) * permanent($m, $n);
		last if $i == $n;
		$m($i,:) .= $mat($i,1:);
	}
	return sclr($sum);
}

my $M = pdl([[2,9,4], [7,5,3], [6,1,8]]);
print "M = $M\n";
print "det(M) = " . $M->determinant . ".\n";
print "det(M) = " . $M->det . ".\n";
print "perm(M) = " . permanent($M) . ".\n";
