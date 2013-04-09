function div_check($x, $y) {
  @trigger_error(''); // a dummy to detect when error didn't occur
  @($x / $y);
  $e = error_get_last();
  return $e['message'] != '';
}
