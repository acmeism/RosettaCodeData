open my $fh, '>:encoding(UTF-8)', $filename or die "Could not open '$filename':  $!";
print $fh $data;
close $fh;
