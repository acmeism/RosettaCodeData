logic: func (a: Bool, b: Bool) {
  println()
  "A=#{a}, B=#{b}:"  println()
  "AND:   #{a && b}" println()
  "OR:    #{a || b}" println()
  "NOT A: #{!a}"     println()
}

main: func {
  logic(true, false)
  logic(true, true)
  logic(false, false)
  logic(false, true)
}
