open my $fh, '<:encoding(UTF-8)', $filename or die "Could not open '$filename':  $!";
my $text;
read $fh, $text, -s $filename;
close $fh;
