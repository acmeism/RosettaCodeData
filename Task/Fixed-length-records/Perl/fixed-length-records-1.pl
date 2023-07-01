open $in,  '<', 'flr-infile.dat';
open $out, '>', 'flr-outfile.dat';

while ($n=sysread($in, $record, 80)) {   # read in fixed sized binary chunks
     syswrite $out, reverse $record;     # write reversed records to file
     print reverse($record)."\n"         # display reversed records, line-by-line
}
close $out;
