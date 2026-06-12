# AWK in unable to print itself.  The closest thing available is to use the
# command line options shown below.
#
# pretty  runs    execution  blank
# prints  script  counts     lines    comments  GAWK option
# ------  ------  ---------  -------  --------  --------------
# yes     no      no         removed  kept      --pretty-print
# yes     yes     yes        removed  removed   --profile
#
# syntax:
#   GAWK --pretty-print=con -f PRINT_ITSELF.AWK
#   GAWK --profile=con -f PRINT_ITSELF.AWK
#
BEGIN {
    for (i=0; i<=9; i++) { # test the pretty print formatting
      if (i ~ /[02468]$/) {
        msg = "even"
      }
      else {
        msg = "odd"
      }
      printf("%d %s\n",i,msg)
    }
    exit(0)
}
