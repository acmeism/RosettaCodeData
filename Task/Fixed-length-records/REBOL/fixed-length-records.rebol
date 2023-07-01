inp: open     %infile.dat
out: open/new %outfile.dat

while [ not empty? line: copy/part inp 80 ][ write out reverse line ]

close inp
close out
