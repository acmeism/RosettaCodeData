$*OUT = './flr-outfile.dat'.IO.open(:w, :bin) orelse .die; # open a file in binary mode for writing
while my $record = $*IN.read(80) {                       # read in fixed sized binary chunks
     $*OUT.write: $record.=reverse;                      # write reversed records out to $outfile
     $*ERR.say: $record.decode('ASCII');                 # display decoded records on STDERR
}
close $*OUT;
