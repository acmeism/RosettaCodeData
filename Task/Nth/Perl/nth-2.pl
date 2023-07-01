use Lingua::EN::Numbers::Ordinate 'ordinate';
foreach my $i (0..25, 250..265, 1000..1025) {
  print ordinate($i),"\n";
}
