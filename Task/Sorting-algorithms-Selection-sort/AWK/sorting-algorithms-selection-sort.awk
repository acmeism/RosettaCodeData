function getminindex(gl, gi, gs)
{
  min = gl[gi]
  gm = gi
  for(gj=gi; gj <= gs; gj++) {
    if ( gl[gj] < min ) {
      min = gl[gj]
      gm = gj
    }
  }
  return gm
}

{
  line[NR] = $0
}
END { # sort it with selection sort
  for(i=1; i <= NR; i++) {
    mi = getminindex(line, i, NR)
    t = line[i]
    line[i] = line[mi];
    line[mi] = t
  }
  #print it
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}
