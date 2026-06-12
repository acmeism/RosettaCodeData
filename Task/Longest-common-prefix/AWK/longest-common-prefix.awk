# syntax: GAWK -f LONGEST_COMMON_PREFIX.AWK
BEGIN {
    words_arr[++n] = "interspecies,interstellar,interstate"
    words_arr[++n] = "throne,throne"
    words_arr[++n] = "throne,dungeon"
    words_arr[++n] = "throne,,throne"
    words_arr[++n] = "cheese"
    words_arr[++n] = ""
    words_arr[++n] = "prefix,suffix"
    words_arr[++n] = "foo,foobar"
    for (i=1; i<=n; i++) {
      str = words_arr[i]
      printf("'%s' = '%s'\n",str,lcp(str))
    }
    exit(0)
}
function lcp(str,  arr,hits,i,j,lcp_leng,n,sw_leng) {
    n = split(str,arr,",")
    if (n == 0) { # null string
      return("")
    }
    if (n == 1) { # only 1 word, then it's the longest
      return(str)
    }
    sw_leng = length(arr[1])
    for (i=2; i<=n; i++) { # find shortest word length
      if (length(arr[i]) < sw_leng) {
        sw_leng = length(arr[i])
      }
    }
    for (i=1; i<=sw_leng; i++) { # find longest common prefix
      hits = 0
      for (j=1; j<n; j++) {
        if (substr(arr[j],1,i) == substr(arr[j+1],1,i)) {
          hits++
        }
      }
      if (hits == 0) {
        break
      }
      if (hits + 1 == n) {
        lcp_leng++
      }
    }
    return(substr(str,1,lcp_leng))
}
