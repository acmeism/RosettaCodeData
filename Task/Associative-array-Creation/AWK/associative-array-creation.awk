BEGIN {
  a["red"] = 0xff0000
  a["green"] = 0x00ff00
  a["blue"] = 0x0000ff
  for (i in a) {
    printf "%8s %06x\n", i, a[i]
  }
  # deleting a key/value
  delete a["red"]
  for (i in a) {
    print i
  }
  # check if a key exists
  print ( "red" in a )   # print 0
  print ( "blue" in a )  # print 1
}
