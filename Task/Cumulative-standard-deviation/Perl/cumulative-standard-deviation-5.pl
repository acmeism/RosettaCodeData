use Math::StdDev;
$d=new Math::StdDev;
foreach my $v ( 2,4,4,4,5,5,7,9 ) {
  $d->Update($v);
  print $d->variance(),"\n"
}
