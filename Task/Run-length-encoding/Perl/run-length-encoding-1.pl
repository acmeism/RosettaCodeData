# functional approach (return the encoded or decoded string)
sub encode {
  (my $str = shift) =~ s {(.)(\1*)} {length($&).$1}gse;
  return $str; }
sub decode {
  (my $str = shift) =~ s {(\d+)(.)} {$2 x $1}gse;
  return $str;}

# procedural approach (modify the argument in place)
sub encode {
  $_[0] =~ s {(.)(\1*)} {length($&).$1}gse; }
sub decode {
  $_[0] =~ s {(\d+)(.)} {$2 x $1}gse; }
