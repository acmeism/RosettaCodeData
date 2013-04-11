sub rot13 {
  my $string = shift;
  $string =~ tr/A-Za-z/N-ZA-Mn-za-m/;
  return $string;
}

print rot13($_) while (<>);
