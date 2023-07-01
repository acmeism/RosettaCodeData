function combsort( a, len,    gap, igap, swap, swaps, i )
{
	gap = len
	swaps = 1
	
	while( gap > 1 || swaps )
	{
		gap /= 1.2473;
		if ( gap < 1 ) gap = 1
		i = swaps = 0
		while( i + gap < len )
		{
			igap = i + int(gap)
			if ( a[i] > a[igap] )
			{
				swap = a[i]
				a[i] = a[igap]
				a[igap] = swap
				swaps = 1
			}
			i++;
		}		
	}
}

BEGIN {
	a[0] = 5
	a[1] = 2
	a[2] = 7
	a[3] = -11
	a[4] = 6
	a[5] = 1
	
	combsort( a, length(a) )
	
	for( i=0; i<length(a); i++ )
		print a[i]
}
