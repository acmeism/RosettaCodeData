function Get-GCD ($x, $y) {
  if ($y -eq 0) { $x } else { Get-GCD $y ($x%$y) }
}
