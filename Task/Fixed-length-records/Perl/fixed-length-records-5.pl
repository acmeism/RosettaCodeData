use Path::Tiny;
path('outfile.dat')->spew(pack '(A64)16', split /\n/, path('sample.txt')->slurp);
