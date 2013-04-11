# --- with command line argument "throws" ---

BEGIN{ th=ARGV[1];
 for(i=0; i<th; i++) cin += (rand()**2 + rand()**2) < 1 ;
 printf("Pi = %8.5f\n",4*cin/th);
}

usage: awk -f pi 2300

Pi =  3.14333
