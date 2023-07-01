BEGIN {
  a["hello"] = 1
  a["world"] = 2
  a["!"] = 3

  # iterate over keys, undefined order
  for(key in a) {
    print key, a[key]
  }
}
