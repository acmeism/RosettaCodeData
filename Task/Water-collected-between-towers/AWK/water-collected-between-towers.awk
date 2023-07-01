# syntax: GAWK -f WATER_COLLECTED_BETWEEN_TOWERS.AWK [-v debug={0|1}]
BEGIN {
    wcbt("1,5,3,7,2")
    wcbt("5,3,7,2,6,4,5,9,1,2")
    wcbt("2,6,3,5,2,8,1,4,2,2,5,3,5,7,4,1")
    wcbt("5,5,5,5")
    wcbt("5,6,7,8")
    wcbt("8,7,7,6")
    wcbt("6,7,10,7,6")
    exit(0)
}
function wcbt(str,  ans,hl,hr,i,n,tower) {
    n = split(str,tower,",")
    for (i=n; i>=0; i--) { # scan right to left
      hr[i] = max(tower[i],(i<n)?hr[i+1]:0)
    }
    for (i=0; i<=n; i++) { # scan left to right
      hl[i] = max(tower[i],(i!=0)?hl[i-1]:0)
      ans += min(hl[i],hr[i]) - tower[i]
    }
    printf("%4d : %s\n",ans,str)
    if (debug == 1) {
      for (i=1; i<=n; i++) { printf("%-4s",tower[i]) } ; print("tower")
      for (i=1; i<=n; i++) { printf("%-4s",hl[i]) } ; print("l-r")
      for (i=1; i<=n; i++) { printf("%-4s",hr[i]) } ; print("r-l")
      for (i=1; i<=n; i++) { printf("%-4s",min(hl[i],hr[i])) } ; print("min")
      for (i=1; i<=n; i++) { printf("%-4s",min(hl[i],hr[i])-tower[i]) } ; print("sum\n")
    }
}
function max(x,y) { return((x > y) ? x : y) }
function min(x,y) { return((x < y) ? x : y) }
