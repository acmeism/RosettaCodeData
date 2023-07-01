function isLongYear($year) {
  return (53 == strftime('%V', gmmktime(0,0,0,12,28,$year)));
}

for ($y=1995; $y<=2045; ++$y) {
  if (isLongYear($y)) {
    printf("%s\n", $y);
  }
}
