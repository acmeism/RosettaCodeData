#!/usr/bin/awk -f
BEGIN {
split("255,0,0,255,255,0",R,",");
split("0,255,0,255,255,0",G,",");
split("0,0,255,0,0,0",B,",");

outfile = "P3.ppm";
printf("P3\n2 3\n255\n") >outfile;
for (k=1; k<=length(R); k++) {
   printf("%3i %3i %3i\n",R[k],G[k],B[k])>outfile
}
close(outfile);
}
