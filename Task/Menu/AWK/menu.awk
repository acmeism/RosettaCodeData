# syntax: GAWK -f MENU.AWK
BEGIN {
    print("you picked:",menu(""))
    print("you picked:",menu("fee fie:huff and puff:mirror mirror:tick tock"))
    exit(0)
}
function menu(str,  ans,arr,i,n) {
    if (str == "") {
      return
    }
    n = split(str,arr,":")
    while (1) {
      print("")
      for (i=1; i<=n; i++) {
        printf("%d - %s\n",i,arr[i])
      }
      printf("? ")
      getline ans
      if (ans in arr) {
        return(arr[ans])
      }
      print("invalid choice")
    }
}
