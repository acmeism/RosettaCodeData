# syntax: GAWK -f MULTISPLIT.AWK
BEGIN {
    str = "a!===b=!=c"
    sep = "(==|!=|=)"
    printf("str: %s\n",str)
    printf("sep: %s\n\n",sep)
    n = split(str,str_arr,sep,sep_arr)
    printf("parsed: ")
    for (i=1; i<=n; i++) {
      printf("'%s'",str_arr[i])
      if (i<n) { printf(" '%s' ",sep_arr[i]) }
    }
    printf("\n\nstrings: ")
    for (i=1; i<=n; i++) {
      printf("'%s' ",str_arr[i])
    }
    printf("\n\nseparators: ")
    for (i=1; i<n; i++) {
      printf("'%s' ",sep_arr[i])
    }
    printf("\n")
    exit(0)
}
