ack: func (m: Int, n: Int) -> Int {
  if (m == 0) {
    n + 1
  } else if (n == 0) {
    ack(m - 1, 1)
  } else {
    ack(m - 1, ack(m, n - 1))
  }
}

main: func {
  for (m in 0..4) {
    for (n in 0..10) {
      "ack(#{m}, #{n}) = #{ack(m, n)}" println()
    }
  }
}
