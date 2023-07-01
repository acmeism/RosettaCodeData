# syntax: GAWK -f CANTOR_SET.AWK
# converted from C
BEGIN {
    WIDTH = 81
    HEIGHT = 5
    for (i=0; i<HEIGHT; ++i) {
      for (j=0; j<WIDTH; ++j) {
        lines[i][j] = "*"
      }
    }
    cantor(0,WIDTH,1)
    for (i=0; i<HEIGHT; ++i) {
      for (j=0; j<WIDTH; ++j) {
        printf("%s",lines[i][j])
      }
      printf("\n")
    }
    exit(0)
}
function cantor(start,leng,indx,  i,j,seg) {
    seg = int(leng/3)
    if (seg == 0) { return }
    for (i=indx; i<HEIGHT; ++i) {
      for (j=start+seg; j<start+seg*2; ++j) {
        lines[i][j] = " "
      }
    }
    cantor(start,seg,indx+1)
    cantor(start+seg*2,seg,indx+1)
}
