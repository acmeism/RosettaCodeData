#!/usr/bin/gawk -f
{
	# compute histogram
	histo[$1] += 1;
};

function mode(HIS) {
    # Computes the mode from Histogram A
    max = 0;
    n = 0; 	
    for (k in HIS) {
	val = HIS[k];
	if (HIS[k] > max) {
	    max = HIS[k];
            n = 1;
	    List[n] = k;	
	} else if (HIS[k] == max)	{
		List[++n] = k; 	
	}
    }	

    for (k=1; k<=n; k++) {
        o = o""OFS""List[k];
    }	
    return o;
}

END {
    print mode(histo);
};
