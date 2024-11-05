# awk -f sierpinski.awk -v n=4 (n being arbitrary height of triangle)
BEGIN{
  n=n?2^n-1:15                                  # default to height 4
  for(i=n;i>=0;i--){                            # height of triangle
    for(k=i;k;k--)printf" "                     # spaces preceding triangle
    for(j=0;j<=n;j++)printf and(i,j)?"  ":"* "  # bitwise if space or *
    print                                       # newline
  }
}
