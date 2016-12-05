proc fact(x: int): int =
  result = 1
  for i in 2..x:
    result = result * i

const fact10 = fact(10)
echo(fact10)
