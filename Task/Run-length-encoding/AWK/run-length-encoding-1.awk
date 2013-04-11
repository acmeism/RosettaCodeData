BEGIN {
 FS=""
}
/^[^0-9]+$/ {
  cp = $1; j = 0
  for(i=1; i <= NF; i++) {
    if ( $i == cp ) {
      j++;
    } else {
      printf("%d%c", j, cp)
      j = 1
    }
    cp = $i
  }
  printf("%d%c", j, cp)
}
