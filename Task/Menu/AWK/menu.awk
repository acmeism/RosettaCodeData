# syntax: GAWK -f MENU.AWK
BEGIN {
    n = split("fee fie:huff and puff:mirror mirror:tick tock",arr,":")
    while (1) {
      print("")
      for (i=1; i<=n; i++) {
        printf("%d - %s\n",i,arr[i])
      }
      print("0 - exit")
      printf("enter number: ")
      getline ans
      if (ans in arr) {
        printf("you picked '%s'\n",arr[ans])
        continue
      }
      if (ans == 0) {
        break
      }
      print("invalid choice")
    }
    exit(0)
}
