sub lookandsay {
  my $str = shift;
  $str =~ s/((.)\2*)/length($1) . $2/ge;
  return $str;
}

my $num = "1";
foreach (1..10) {
  print "$num\n";
  $num = lookandsay($num);
}
