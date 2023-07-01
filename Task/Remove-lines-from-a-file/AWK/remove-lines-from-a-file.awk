# syntax: GAWK -f REMOVE_LINES_FROM_A_FILE.AWK
# show files after lines are removed:
#   GAWK "FNR==1{print(FILENAME)};{print(FNR,$0)}" TEST1 TEST2 TEST3
BEGIN {
    build_test_data()
    remove_lines("TEST0",1,1)
    remove_lines("TEST1",3,4)
    remove_lines("TEST2",9,3)
    remove_lines("TEST3",11,1)
    exit(errors+0)
}
function build_test_data(  fn,i,j) { # create 3 files with 10 lines each
    for (i=1; i<=3; i++) {
      fn = "TEST" i
      for (j=1; j<=10; j++) {
        printf("line %d\n",j) >fn
      }
      close(fn)
    }
}
function remove_lines(fn,start,number_of_lines,  arr,fnr,i,n,rec,stop) {
    stop = start + number_of_lines - 1
    while (getline rec <fn > 0) { # read file
      fnr++
      if (fnr < start || fnr > stop) {
        arr[++n] = rec
      }
    }
    close(fn)
    if (fnr == 0) {
      printf("error: file %s not found\n",fn)
      errors = 1
      return
    }
    for (i=1; i<=n; i++) { # write file
      printf("%s\n",arr[i]) >fn
    }
    close(fn)
    if (stop > fnr) {
      printf("error: file %s trying to remove nonexistent lines\n",fn)
      errors = 1
    }
}
