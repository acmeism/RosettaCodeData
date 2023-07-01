{
local ($/, @ARGV) = (\80, 'infile.dat');
open my $out, '>', 'outfile.dat' or die $!;
print $out scalar reverse while <>; # can read fixed length too :)
close $out;
}
