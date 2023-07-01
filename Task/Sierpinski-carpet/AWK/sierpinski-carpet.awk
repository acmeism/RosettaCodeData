# WSC.AWK - Waclaw Sierpinski's carpet contributed by Dan Nielsen
#
# syntax: GAWK -f WSC.AWK [-v o={a|A}{b|B}] [-v X=anychar] iterations
#
#   -v o=ab default
#      a|A  loose weave | tight weave
#      b|B  don't show | show how the carpet is built
#   -v X=?  Carpet is built with X's. The character assigned to X replaces all X's.
#
#   iterations
#      The number of iterations. The default is 0 which produces one carpet.
#
# what is the difference between a loose weave and a tight weave:
#   loose                tight
#   X X X X X X X X X    XXXXXXXXX
#   X   X X   X X   X    X XX XX X
#   X X X X X X X X X    XXXXXXXXX
#   X X X       X X X    XXX   XXX
#   X   X       X   X    X X   X X
#   X X X       X X X    XXX   XXX
#   X X X X X X X X X    XXXXXXXXX
#   X   X X   X X   X    X XX XX X
#   X X X X X X X X X    XXXXXXXXX
#
# examples:
#   GAWK -f WSC.AWK 2
#   GAWK -f WSC.AWK -v o=Ab -v X=# 2
#   GAWK -f WSC.AWK -v o=Ab -v X=\xDB 2
#
BEGIN {
    optns = (o == "") ? "ab" : o
    n = ARGV[1] + 0 # iterations
    if (n !~ /^[0-9]+$/) { exit(1) }
    seed = (optns ~ /A/) ? "XXX,X X,XXX" : "X X X ,X   X ,X X X " # tight/loose weave
    leng = row = split(seed,A,",") # seed the array
    for (i=1; i<=n; i++) { # build carpet
      for (a=1; a<=3; a++) {
        row = 0
        for (b=1; b<=3; b++) {
          for (c=1; c<=leng; c++) {
            row++
            tmp = (a == 2 && b == 2) ? sprintf("%*s",length(A[c]),"") : A[c]
            B[row] = B[row] tmp
          }
          if (optns ~ /B/) { # show how the carpet is built
            if (max_row < row+0) { max_row = row }
            for (r=1; r<=max_row; r++) {
              printf("i=%d row=%02d a=%d b=%d '%s'\n",i,r,a,b,B[r])
            }
            print("")
          }
        }
      }
      leng = row
      for (j=1; j<=row; j++) { A[j] = B[j] } # re-seed the array
      for (j in B) { delete B[j] } # delete work array
    }
    for (j=1; j<=row; j++) { # print carpet
      if (X != "") { gsub(/X/,substr(X,1,1),A[j]) }
      sub(/ +$/,"",A[j])
      printf("%s\n",A[j])
    }
    exit(0)
}
