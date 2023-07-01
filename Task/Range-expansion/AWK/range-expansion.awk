#!/usr/bin/awk -f
BEGIN {	FS=","; }

{	s="";
	for (i=1; i<=NF; i++) { expand($i); }
	print substr(s,2);
}

function expand(a) {
	idx = match(a,/[0-9]-/);
	if (idx==0) {
		s = s","a; 	
		return;
	}
	
	start= substr(a,1, idx)+0;
	stop = substr(a,idx+2)+0;
	for (m = start; m <= stop; m++) {
		s = s","m; 	
	}
	return;
}
