use File::Temp;
$fh = new File::Temp;
print $fh->filename, "\n";
close $fh;
