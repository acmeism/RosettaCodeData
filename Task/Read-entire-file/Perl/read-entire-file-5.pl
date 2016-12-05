my $text;
{
  local $/ = undef;
  open my $fh, '<:encoding(UTF-8)', $filename or die "Could not open '$filename':  $!";
  $text = <$fh>;
  close $fh;
}
