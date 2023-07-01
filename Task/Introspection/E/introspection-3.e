{
  var sum := 0
  for &x in interp.getTopScope() { sum += try { x :int } catch _ { 0 } }
  sum
}
