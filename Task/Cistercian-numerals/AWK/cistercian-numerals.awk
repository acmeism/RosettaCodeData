# syntax: GAWK -f CISTERCIAN_NUMERALS.AWK [-v debug={0|1}] [-v xc=anychar] numbers 0-9999 ...
#
# example: GAWK -f CISTERCIAN_NUMERALS.AWK 0 1 20 300 4000 5555 6789 1995 10000
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    cistercian_init()
    for (i=1; i<=ARGC-1; i++) {
      cistercian1(ARGV[i])
    }
    exit(0)
}
function cistercian1(n,  i) {
    printf("\n%6s\n",n)
    if (!(n ~ /^[0-9]+$/ && length(n) <= 4)) {
      print("invalid")
      return
    }
    n = sprintf("%04d",n)
    cistercian2(2,1,substr(n,3,1),substr(n,4,1))
    for (i=1; i<=5; i++) { # separator between upper and lower parts
      printf("%5s%1s%5s\n","",xc,"")
    }
    cistercian2(4,3,substr(n,1,1),substr(n,2,1))
}
function cistercian2(i1,i2,n1,n2,  i,L,R) {
    for (i=1; i<=5; i++) {
      L = substr(cn_arr[i1][i],n1*6+2,5)
      R = substr(cn_arr[i2][i],n2*6+2,5)
      printf("%5s%1s%5s\n",L,xc,R)
    }
}
function cistercian_init(  header,i,j,LL,LR,UL,UR) {
# 1-9 upper-right
    cn_arr[1][++UR] = ":xxxxx:     :x    :    x:xxxxx:    x:xxxxx:    x:xxxxx:"
    cn_arr[1][++UR] = ":     :     : x   :   x :   x :    x:    x:    x:    x:"
    cn_arr[1][++UR] = ":     :     :  x  :  x  :  x  :    x:    x:    x:    x:"
    cn_arr[1][++UR] = ":     :     :   x : x   : x   :    x:    x:    x:    x:"
    cn_arr[1][++UR] = ":     :xxxxx:    x:x    :x    :    x:    x:xxxxx:xxxxx:"
# 10-90 upper-left
    cn_arr[2][++UL] = ":xxxxx:     :    x:x    :xxxxx:x    :xxxxx:x    :xxxxx:"
    cn_arr[2][++UL] = ":     :     :   x : x   : x   :x    :x    :x    :x    :"
    cn_arr[2][++UL] = ":     :     :  x  :  x  :  x  :x    :x    :x    :x    :"
    cn_arr[2][++UL] = ":     :     : x   :   x :   x :x    :x    :x    :x    :"
    cn_arr[2][++UL] = ":     :xxxxx:x    :    x:    x:x    :x    :xxxxx:xxxxx:"
# 100-900 lower-right
    cn_arr[3][++LR] = ":     :xxxxx:    x:x    :x    :    x:    x:xxxxx:xxxxx:"
    cn_arr[3][++LR] = ":     :     :   x : x   : x   :    x:    x:    x:    x:"
    cn_arr[3][++LR] = ":     :     :  x  :  x  :  x  :    x:    x:    x:    x:"
    cn_arr[3][++LR] = ":     :     : x   :   x :   x :    x:    x:    x:    x:"
    cn_arr[3][++LR] = ":xxxxx:     :x    :    x:xxxxx:    x:xxxxx:    x:xxxxx:"
# 1000-9000 lower-left
    cn_arr[4][++LL] = ":     :xxxxx:x    :    x:    x:x    :x    :xxxxx:xxxxx:"
    cn_arr[4][++LL] = ":     :     : x   :   x :   x :x    :x    :x    :x    :"
    cn_arr[4][++LL] = ":     :     :  x  :  x  :  x  :x    :x    :x    :x    :"
    cn_arr[4][++LL] = ":     :     :   x : x   : x   :x    :x    :x    :x    :"
    cn_arr[4][++LL] = ":xxxxx:     :    x:x    :xxxxx:x    :xxxxx:x    :xxxxx:"
    header =    ":00000:11111:22222:33333:44444:55555:66666:77777:88888:99999:"
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    sub(/^ +/,"",xc)
    xc = (xc == "") ? "x" : substr(xc,1,1) # substitution character
    for (i in cn_arr) {
      for (j in cn_arr[i]) {
        gsub(/x/,xc,cn_arr[i][j]) # change "x" to substitution character
        cn_arr[i][j] = sprintf(":%5s%s","",cn_arr[i][j]) # add zero column to table
        if (debug == 1) { printf("%s %2s %d.%d\n",cn_arr[i][j],substr("URULLRLL",i*2-1,2),i,j) }
      }
    }
    if (debug == 1) { printf("%s\n",header) }
}
