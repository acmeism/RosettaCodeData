proc recurse(i): int =
  echo i
  recurse(i+1)
echo recurse(0)
