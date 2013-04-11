function first($func) {
  return $func();
}

$result = first(function() { return 'second'; });
