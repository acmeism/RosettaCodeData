# syntax: GAWK -f DAMM_ALGORITHM.AWK
BEGIN {
    damm_init()
    leng = split("5724,5727,112946",arr,",") # test cases
    for (i=1; i<=leng; i++) {
      n = arr[i]
      printf("%s %s\n",damm_check(n),n)
    }
    exit(0)
}
function damm_check(n,  a,i) {
    a = 0
    for (i=1; i<=length(n); i++) {
      a = substr(damm[a],substr(n,i,1)+1,1)
    }
    return(a == 0 ? "T" : "F")
}
function damm_init() {
#              0123456789
    damm[0] = "0317598642"
    damm[1] = "7092154863"
    damm[2] = "4206871359"
    damm[3] = "1750983426"
    damm[4] = "6123045978"
    damm[5] = "3674209581"
    damm[6] = "5869720134"
    damm[7] = "8945362017"
    damm[8] = "9438617205"
    damm[9] = "2581436790"
}
