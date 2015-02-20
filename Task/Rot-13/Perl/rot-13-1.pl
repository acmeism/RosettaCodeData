sub rot13 {
  shift =~ tr/A-Za-z/N-ZA-Mn-za-m/r;
}

print rot13($_) while (<>);
