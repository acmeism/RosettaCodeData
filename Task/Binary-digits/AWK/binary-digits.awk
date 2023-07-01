BEGIN {
  print tobinary(0)
  print tobinary(1)
  print tobinary(5)
  print tobinary(50)
  print tobinary(9000)
}

function tobinary(num) {
  outstr = num % 2
  while (num = int(num / 2))
    outstr = (num % 2) outstr
  return outstr
}
