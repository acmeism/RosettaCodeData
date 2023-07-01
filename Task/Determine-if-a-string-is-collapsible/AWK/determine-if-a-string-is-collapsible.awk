# syntax: GAWK -f DETERMINE_IF_A_STRING_IS_COLLAPSIBLE.AWK
BEGIN {
    for (i=1; i<=9; i++) {
      for (j=1; j<=i; j++) {
        arr[0] = arr[0] i
      }
    }
    arr[++n] = ""
    arr[++n] = "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
    arr[++n] = "..1111111111111111111111111111111111111111111111111111111111111117777888"
    arr[++n] = "I never give 'em hell, I just tell the truth, and they think it's hell. "
    arr[++n] = "                                                    --- Harry S Truman  "
    arr[++n] = "The better the 4-wheel drive, the further you'll be from help when ya get stuck!"
    arr[++n] = "headmistressship"
    for (i=0; i<=n; i++) {
      main(arr[i])
    }
    exit(0)
}
function main(str,  c,i,new_str,prev_c) {
    for (i=1; i<=length(str); i++) {
      c = substr(str,i,1)
      if (prev_c != c) {
        prev_c = c
        new_str = new_str c
      }
    }
    printf("old: %2d <<<%s>>>\n",length(str),str)
    printf("new: %2d <<<%s>>>\n\n",length(new_str),new_str)
}
