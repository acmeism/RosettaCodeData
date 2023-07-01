use Path::Tiny;
path('outfile.dat')->spew(reverse unpack '(a80)*', reverse path('infile.dat')->slurp);
