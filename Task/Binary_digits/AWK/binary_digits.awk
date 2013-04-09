BEGIN {
  print tobinary(5)
  print tobinary(50)
  print tobinary(9000)
}

function tobinary(num) {
  outstr = ""
  l = num
  while ( l ) {
    if ( l%2 == 0 ) {
      outstr = "0" outstr
    } else {
      outstr = "1" outstr
    }
    l = int(l/2)
  }
  # Make sure we output a zero for a value of zero
  if ( outstr == "" ) {
    outstr = "0"
  }
  return outstr
}
