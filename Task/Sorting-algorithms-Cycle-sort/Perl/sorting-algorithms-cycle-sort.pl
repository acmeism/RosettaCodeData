use strict;
use warnings;

sub cycleSort :prototype(@) {
	my ($array) = @_;
	my $writes = 0;
	
	my @alreadysorted;
	
	# For each index except the last:
	for my $start ( 0 .. $#$array - 1 ) {
		next if $alreadysorted[$start];
		my $item = $array->[$start];
		# If there are N items less than $item, then we
		# must move $item N items rightward.
		my $pos = $start + grep $array->[$_] lt $item, $start + 1 .. $#$array;
		# If the item is where it should be, continue.
		next if $pos == $start;
		# If $item is one of several repetitions, move it to the right
		# of the last repeat.
		++$pos while $item eq $array->[ $pos ];
		# Store $item at $pos, where it belongs, and fetch the
		# value that had been at $pos, and put it in $item.
		($array->[ $pos ], $item) = ($item, $array->[ $pos ]);
		++$writes;

		# Whatever $item is now, it certainly doesn't belong at $pos;
		do {
			# Find the correct $pos,
			$pos = $start + grep $array->[$_] lt $item, $start+1 .. $#$array;
			++$pos while $item eq $array->[ $pos ];
			# Swap the value there with $item,
			($array->[ $pos ] , $item ) = ($item, $array->[ $pos ]);
			# And mark $pos as having the correct value in it..
			$alreadysorted[ $pos ] = 1;
			++$writes;
			# The loop ends after we have just written an item to $start
		} while $pos != $start;
	}
	$writes;
}

use List::Util 'shuffle';
my @test = shuffle( ('a'..'z') x 2 );
print "Before sorting: @test\n";
print "There were ", cycleSort( \@test ), " writes\n";
print "After  sorting: @test\n";
