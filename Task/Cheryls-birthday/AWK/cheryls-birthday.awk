# syntax: GAWK -f CHERYLS_BIRTHDAY.AWK [-v debug={0|1}]
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    debug += 0
    PROCINFO["sorted_in"] = "@ind_num_asc" ; SORTTYPE = 1
    n = split("05/15,05/16,05/19,06/17,06/18,07/14,07/16,08/14,08/15,08/17",arr,",")
    for (i=1; i<=n; i++) { # move dates to a more friendly structure
      mmdd_arr[arr[i]] = ""
    }
    print("Cheryl offers these ten MM/DD choices:")
    cb_show_dates()
    printf("Cheryl then tells Albert her birth 'month' and Bernard her birth 'day'.\n\n")
    print("1. Albert: I don't know when Cheryl's birthday is, but I know that Bernard does not know too.")
    cb_filter1()
    print("2. Bernard: At first I don't know when Cheryl's birthday is, but I know now.")
    cb_filter2()
    print("3. Albert: Then I also know when Cheryl's birthday is.")
    cb_filter3()
    exit(0)
}
function cb_filter1(  i,j) {
    print("deduction: the month cannot have a unique day, leaving:")
    cb_load_arrays(4)
    for (j in arr1) {
      if (arr1[j] == 1) {
        if (debug) { printf("unique day %s\n",j) }
        arr3[arr2[j]] = ""
      }
    }
    cb_remove_dates()
}
function cb_filter2(  i,j) {
    print("deduction: the day must be unique, leaving:")
    cb_load_arrays(4)
    for (j in arr1) {
      if (arr1[j] > 1) {
        if (debug) { printf("non-unique day %s\n",j) }
        arr3[j] = ""
      }
    }
    cb_remove_dates("...")
}
function cb_filter3(  i,j) {
    print("deduction: the month must be unique, leaving:")
    cb_load_arrays(1)
    for (j in arr1) {
      if (arr1[j] > 1) {
        if (debug) { printf("non-unique month %s\n",j) }
        arr3[j] = ""
      }
    }
    cb_remove_dates()
}
function cb_load_arrays(col,  i,key) {
    delete arr1
    delete arr2
    delete arr3
    for (i in mmdd_arr) {
      key = substr(i,col,2)
      arr1[key]++
      arr2[key] = substr(i,1,2)
    }
}
function cb_remove_dates(pattern,  i,j) {
    for (j in arr3) {
      for (i in mmdd_arr) {
        if (i ~ ("^" pattern j)) {
          if (debug) { printf("removing %s\n",i) }
          delete mmdd_arr[i]
        }
      }
    }
    cb_show_dates()
}
function cb_show_dates(  i) {
    if (debug) { printf("%d remaining\n",length(mmdd_arr)) }
    for (i in mmdd_arr) {
      printf("%s ",i)
    }
    printf("\n\n")
}
