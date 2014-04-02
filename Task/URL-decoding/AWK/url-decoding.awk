# syntax:
awk '
BEGIN {
    str = "http%3A%2F%2Ffoo%20bar%2F" # "http://foo bar/"
    printf("%s\n",str)
    len=length(str)
    for (i=1;i<=len;i++) {
      if ( substr(str,i,1) == "%") {
        L = substr(str,1,i-1) # chars to left of "%"
        M = substr(str,i+1,2) # 2 chars to right of "%"
        R = substr(str,i+3)   # chars to right of "%xx"
        str = sprintf("%s%c%s",L,hex2dec(M),R)
      }
    }
    printf("%s\n",str)
    exit(0)
}
function hex2dec(s,  num) {
    num = index("0123456789ABCDEF",toupper(substr(s,length(s)))) - 1
    sub(/.$/,"",s)
    return num + (length(s) ? 16*hex2dec(s) : 0)
} '
