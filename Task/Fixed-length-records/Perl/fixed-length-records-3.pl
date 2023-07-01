use Path::Tiny;
path('outfile.dat')->spew(path('infile.dat')->slurp =~ s/.{80}/reverse $&/gesr);
