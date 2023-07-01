function ord(a)
{
  return amap[a]
}

function sedol_checksum(sed)
{
  sw[1] = 1; sw[2] = 3; sw[3] = 1
  sw[4] = 7; sw[5] = 3; sw[6] = 9
  sum = 0
  for(i=1; i <= 6; i++) {
    c = substr(toupper(sed), i, 1)
    if ( c ~ /[[:digit:]]/ ) {
      sum += c*sw[i]
    } else {
      sum += (ord(c)-ord("A")+10)*sw[i]
    }
  }
  return (10 - (sum % 10)) % 10
}

BEGIN { # prepare amap for ord
  for(_i=0;_i<256;_i++) {
    astr = sprintf("%c", _i)
    amap[astr] = _i
  }
}

/[AEIOUaeiou]/ {
  print "'" $0 "' not a valid SEDOL code"
  next
}
{
  if ( (length($0) > 7) || (length($0) < 6) ) {
    print "'" $0 "' is too long or too short to be valid SEDOL"
    next
  }
  sedol = substr($0, 1, 6)
  sedolcheck = sedol_checksum(sedol)
  if ( length($0) == 7 ) {
    if ( (sedol sedolcheck) != $0 ) {
      print sedol sedolcheck " (original " $0 " has wrong check digit"
    } else {
      print sedol sedolcheck
    }
  } else {
    print sedol sedolcheck
  }
}
