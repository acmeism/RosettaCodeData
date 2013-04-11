sub encode
 {my $str = shift;
  $str =~ s {(.)(\1{0,254})} {pack("C",(length($2) + 1)) . $1 }gse;
  return $str;}

sub decode
{
     my @str = split //, shift;
     my $r = "";
     foreach my $i (0 .. scalar(@str)/2-1) {
	 $r .= $str[2*$i + 1] x unpack("C", $str[2*$i]);
     }
     return $r;
}
