# syntax: GAWK -f TOP_RANK_PER_GROUP.AWK [n]
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    arrA[++n] = "Employee Name,Employee ID,Salary,Department" # raw data
    arrA[++n] = "Tyler Bennett,E10297,32000,D101"
    arrA[++n] = "John Rappl,E21437,47000,D050"
    arrA[++n] = "George Woltman,E00127,53500,D101"
    arrA[++n] = "Adam Smith,E63535,18000,D202"
    arrA[++n] = "Claire Buckman,E39876,27800,D202"
    arrA[++n] = "David McClellan,E04242,41500,D101"
    arrA[++n] = "Rich Holcomb,E01234,49500,D202"
    arrA[++n] = "Nathan Adams,E41298,21900,D050"
    arrA[++n] = "Richard Potter,E43128,15900,D101"
    arrA[++n] = "David Motsinger,E27002,19250,D202"
    arrA[++n] = "Tim Sampair,E03033,27000,D101"
    arrA[++n] = "Kim Arlich,E10001,57000,D190"
    arrA[++n] = "Timothy Grove,E16398,29900,D190"
    for (i=2; i<=n; i++) { # build internal structure
      split(arrA[i],arrB,",")
      arrC[arrB[4]][arrB[3]][arrB[2] " " arrB[1]] # I.E. arrC[dept][salary][id " " name]
    }
    show = (ARGV[1] == "") ? 1 : ARGV[1] # employees to show per department
    printf("DEPT SALARY EMPID  NAME\n\n") # produce report
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i in arrC) {
      PROCINFO["sorted_in"] = "@ind_str_desc" ; SORTTYPE = 9
      shown = 0
      for (j in arrC[i]) {
        PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
        for (k in arrC[i][j]) {
          if (shown++ < show) {
            printf("%-4s %6s %s\n",i,j,k)
            printed++
          }
        }
      }
      if (printed > 0) { print("") }
      printed = 0
    }
    exit(0)
}
