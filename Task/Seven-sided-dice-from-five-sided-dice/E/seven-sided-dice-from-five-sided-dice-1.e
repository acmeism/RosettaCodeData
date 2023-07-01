def dice5() {
  return entropy.nextInt(5) + 1
}

def dice7() {
  var d55 := null
  while ((d55 := 5 * dice5() + dice5() - 6) >= 21) {}
  return d55 %% 7 + 1
}
