# syntax: GAWK -f DETERMINE_IF_A_STRING_IS_SQUEEZABLE.AWK
BEGIN {
    arr[++n] = ""                                                                                 ; arr2[n] = " "
    arr[++n] = "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "       ; arr2[n] = "-"
    arr[++n] = "..1111111111111111111111111111111111111111111111111111111111111117777888"         ; arr2[n] = "7"
    arr[++n] = "I never give 'em hell, I just tell the truth, and they think it's hell. "         ; arr2[n] = "."
    arr[++n] = "                                                    --- Harry S Truman  "         ; arr2[n] = " -r"
    arr[++n] = "The better the 4-wheel drive, the further you'll be from help when ya get stuck!" ; arr2[n] = "e"
    arr[++n] = "headmistressship"                                                                 ; arr2[n] = "s"
    for (i=1; i<=n; i++) {
      for (j=1; j<=length(arr2[i]); j++) {
        main(arr[i],substr(arr2[i],j,1))
      }
    }
    exit(0)
}
function main(str,chr,  c,i,new_str,prev_c) {
    for (i=1; i<=length(str); i++) {
      c = substr(str,i,1)
      if (!(prev_c == c && c == chr)) {
        prev_c = c
        new_str = new_str c
      }
    }
    printf("use: '%s'\n",chr)
    printf("old: %2d <<<%s>>>\n",length(str),str)
    printf("new: %2d <<<%s>>>\n\n",length(new_str),new_str)
}
