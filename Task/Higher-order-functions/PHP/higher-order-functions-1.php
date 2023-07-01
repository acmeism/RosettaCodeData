function first($func) {
  return $func();
}

function second() {
  return 'second';
}

$result = first('second');
