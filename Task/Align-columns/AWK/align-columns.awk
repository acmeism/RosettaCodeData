BEGIN {
  FS="$"
  lcounter = 1
  maxfield = 0
  # justification; pick one
  #justify = "left"
  justify = "center"
  #justify = "right"
}
{
  if ( NF > maxfield ) maxfield = NF;
  for(i=1; i <= NF; i++) {
    line[lcounter,i] = $i
    if ( longest[i] == "" ) longest[i] = 0;
    if ( length($i) > longest[i] ) longest[i] = length($i);
  }
  lcounter++
}
END {
  just = (justify == "left") ? "-" : ""
  for(i=1; i <= NR; i++) {
    for(j=1; j <= maxfield; j++) {
      if ( justify != "center" ) {
	template = "%" just longest[j] "s "
      } else {
	v = int((longest[j] - length(line[i,j]))/2)
	rt = "%" v+1 "s%%-%ds"
	template = sprintf(rt, "", longest[j] - v)
      }
      printf(template, line[i,j])
    }
    print ""
  }
}
