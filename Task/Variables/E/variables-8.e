def getUniqueId(&counter) {
  counter += 1
  return counter
}

var idc := 0
getUniqueId(&idc) # returns 1
getUniqueId(&idc) # returns 2
