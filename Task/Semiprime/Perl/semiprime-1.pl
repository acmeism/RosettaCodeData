use ntheory "is_semiprime";
for ([1..100], [1675..1681], [2,4,99,100,1679,5030,32768,1234567,9876543,900660121]) {
  print join(" ",grep { is_semiprime($_) } @$_),"\n";
}
