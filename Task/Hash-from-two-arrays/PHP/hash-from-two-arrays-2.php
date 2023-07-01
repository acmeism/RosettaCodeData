$keys = array('a', 'b', 'c');
$values = array(1, 2, 3);
$hash = array();
for ($idx = 0; $idx < count($keys); $idx++) {
  $hash[$keys[$idx]] = $values[$idx];
}
