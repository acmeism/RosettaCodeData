#!/usr/bin/awk -f
BEGIN {
   print isbb("[]")
   print isbb("][")
   print isbb("][][")
   print isbb("[][]")
   print isbb("[][][]")
   print isbb("[]][[]")
}

function isbb(x) {
   s = 0;
   for (k=1; k<=length(x); k++) {
	c = substr(x,k,1);
	if (c=="[") {s++;}	
	else { if (c=="]") s--;	}

        if (s<0) {return 0};
   } 	
   return (s==0);
}
