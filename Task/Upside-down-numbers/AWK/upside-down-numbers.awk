# syntax: GAWK -f UPSIDE-DOWN_NUMBERS.AWK
BEGIN {
    limit = 50
    printf("First %d upside-down numbers:\n",limit)
    while (1) {
      if (++n ~ /0/) {
        continue
      }
      leng = length(n)
      if (leng ~ /[13579]$/) {
        if (substr(n,int(leng/2)+1,1) != 5) {
          continue
        }
      }
      flag = 1
      for (i=1; i<=int(leng/2); i++) {
        L = substr(n,i,1)
        R = substr(n,leng-i+1,1)
        if (L+R != 10) {
          flag = 0
          break
        }
      }
      if (flag == 1) {
        if (++count <= limit) {
          printf("%5d%s",n,count%10?"":"\n")
        }
        else if (count == 500) {
          printf("\n%4d %8d\n",count,n)
        }
        else if (count == 5000) {
          printf("%4d %8d\n",count,n)
          break
        }
      }
    }
    exit(0)
}
