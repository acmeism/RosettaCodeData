# usage: awk -f rot13.awk
BEGIN {
  for(i=0; i < 256; i++) {
    amap[sprintf("%c", i)] = i
  }
  for(l=amap["a"]; l <= amap["z"]; l++) {
    rot13[l] = sprintf("%c", (((l-amap["a"])+13) % 26 ) + amap["a"])
  }
  FS = ""
}
{
  o = ""
  for(i=1; i <= NF; i++) {
    if ( amap[tolower($i)] in rot13 ) {
      c = rot13[amap[tolower($i)]]
      if ( tolower($i) != $i ) c = toupper(c)
      o = o c
    } else {
      o = o $i
    }
  }
  print o
}
