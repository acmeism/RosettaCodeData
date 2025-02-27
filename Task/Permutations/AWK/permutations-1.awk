# syntax: GAWK -f PERMUTATIONS.AWK [-v sep=x] [word]
#
# examples:
#   REM all permutations on one line
#   GAWK -f PERMUTATIONS.AWK
#
#   REM all permutations on a separate line
#   GAWK -f PERMUTATIONS.AWK -v sep="\n"
#
#   REM use a different word
#   GAWK -f PERMUTATIONS.AWK Gwen
#
#   REM command used for RosettaCode output
#   GAWK -f PERMUTATIONS.AWK -v sep="\n" Gwen
#
BEGIN {
    sep = (sep == "") ? " " : substr(sep,1,1)
    str = (ARGC == 1) ? "abc" : ARGV[1]
    printf("%s%s",str,sep)
    leng = length(str)
    for (i=1; i<=leng; i++) {
      arr[i-1] = substr(str,i,1)
    }
    ana_permute(0)
    exit(0)
}
function ana_permute(pos,  i,j,str) {
    if (leng - pos < 2) { return }
    for (i=pos; i<leng-1; i++) {
      ana_permute(pos+1)
      ana_rotate(pos)
      for (j=0; j<=leng-1; j++) {
        printf("%s",arr[j])
      }
      printf(sep)
    }
    ana_permute(pos+1)
    ana_rotate(pos)
}
function ana_rotate(pos,  c,i) {
    c = arr[pos]
    for (i=pos; i<leng-1; i++) {
      arr[i] = arr[i+1]
    }
    arr[leng-1] = c
}
