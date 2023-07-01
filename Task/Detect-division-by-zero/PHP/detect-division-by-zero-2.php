function div_check($x, $y) {
  return @($x / $y) === FALSE; // works at least in PHP/5.2.6-3ubuntu4.5
}
