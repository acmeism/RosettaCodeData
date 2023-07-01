# syntax: GAWK -f HASH_JOIN.AWK [-v debug={0|1}] TABLE_A TABLE_B
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    FS = ","
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    if (ARGC-1 != 2) {
      print("error: incorrect number of arguments") ; errors++
      exit # go to END
    }
}
{   if (NR == FNR) { # table A
      if (FNR == 1) {
        a_head = prefix_column_names("A")
        next
      }
      a_arr[$2][$1] = $0 # [name][age]
    }
    if (NR != FNR) { # table B
      if (FNR == 1) {
        b_head = prefix_column_names("B")
        next
      }
      b_arr[$1][$2] = $0 # [character][nemesis]
    }
}
END {
    if (errors > 0) { exit(1) }
    if (debug == 1) {
      dump_table(a_arr,a_head)
      dump_table(b_arr,b_head)
    }
    printf("%s%s%s\n",a_head,FS,b_head) # table heading
    for (i in a_arr) {
      if (i in b_arr) {
        for (j in a_arr[i]) {
          for (k in b_arr[i]) {
            print(a_arr[i][j] FS b_arr[i][k]) # join table A & table B
          }
        }
      }
    }
    exit(0)
}
function dump_table(arr,heading,  i,j) {
    printf("%s\n",heading)
    for (i in arr) {
      for (j in arr[i]) {
        printf("%s\n",arr[i][j])
      }
    }
    print("")
}
function prefix_column_names(p,  tmp) {
    tmp = p "." $0
    gsub(/,/,"&" p ".",tmp)
    return(tmp)
}
