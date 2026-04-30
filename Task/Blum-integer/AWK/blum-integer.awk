# syntax: GAWK -f BLUM_INTEGER.AWK
# converted from FutureBasic
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    n = 3
    prime2 = 0
    print("The first 50 Blum integers:")
    while (1) {
      if (is_semiprime(n)) {
        if (prime1 % 4 == 3) {
          prime2 = n / prime1
          if ((prime2 != prime1) && (prime2 % 4 == 3)) {
            arr[substr(n,length(n),1)]++
            total++
            if (++count <= 50) {
              printf("%4d%s",n,count%10?"":"\n")
            }
            if (count ~ /^(26828|[1-4]00000)$/) {
              printf("\nThe %6dth Blum integer: %7d",count,n)
              if (count >= 400000) {
                break
              }
            }
          }
        }
      }
      n += 2
    }
    PROCINFO["sorted_in"] = "@ind_num_asc" ; SORTTYPE = 1
    printf("\n\nFor Blum integers up to %d:\n",count)
    for (i in arr) {
      printf("%7.3f%% end in %d\n",arr[i]/total*100,i)
    }
    exit(0)
}
function is_semiprime(n,  c,d) {
    c = 0
    d = 3
    while (d * d <= n) {
      while (n % d == 0) {
        if (c == 2) { return(0) }
        n /= d
        c++
      }
      d += 2
    }
    prime1 = n
    return(c == 1)
}
