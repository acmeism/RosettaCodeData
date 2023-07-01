use Path::Tiny;
path('sample2.txt')->spew(map "$_\n", unpack '(A64)16', path('outfile.dat')->slurp);
