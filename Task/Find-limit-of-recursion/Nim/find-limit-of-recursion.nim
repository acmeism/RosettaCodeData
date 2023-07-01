proc recurse(i: int): int =
  echo i
  recurse(i+1)
echo recurse(0)
