use strict;

sub gnome_sort
{
    my @a = @_;

    my $size = scalar(@a);
    my $i = 1;
    my $j = 2;
    while($i < $size) {
	if ( $a[$i-1] <= $a[$i] ) {
	    $i = $j;
	    $j++;
	} else {
	    @a[$i, $i-1] = @a[$i-1, $i];
	    $i--;
	    if ($i == 0) {
		$i = $j;
		$j++;
	    }
	}
    }
    return @a;
}
