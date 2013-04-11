use File::Temp qw(tempfile);
$fh = tempfile();
($fh2, $filename) = tempfile(); # this file stays around by default
print "$filename\n";
close $fh;
close $fh2;
