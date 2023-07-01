fizz: func (n: Int) -> Bool {
  if(n % 3 == 0) {
    printf("Fizz")
    return true
  }
  return false
}

buzz: func (n: Int) -> Bool {
  if(n % 5 == 0) {
    printf("Buzz")
    return true
  }
  return false
}

main: func {
  for(n in 1..100) {
    fizz:= fizz(n)
    buzz:= buzz(n)
    fizz || buzz || printf("%d", n)
    println()
  }
}
