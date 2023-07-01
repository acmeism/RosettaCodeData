# syntax: GAWK -f PASSWORD_GENERATOR.AWK [-v mask=x] [-v xt=x]
#
# examples:
#   REM 4 character passwords using Rosetta Code default of: lower, upper, number, other
#   GAWK -f PASSWORD_GENERATOR.AWK
#
#   REM 8 character passwords; Rosetta Code default plus another four
#   GAWK -f PASSWORD_GENERATOR.AWK -v mask=LUNPEEEE
#
#   REM 8 character passwords ignoring Rosetta Code requirement
#   GAWK -f PASSWORD_GENERATOR.AWK -v mask=EEEEEEEE
#
#   REM help
#   GAWK -f PASSWORD_GENERATOR.AWK ?
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    srand()
# setup strings of valid characters used by mask
    arr["L"] = "abcdefghijklmnopqrstuvwxyz"        # Lower case
    arr["U"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"        # Upper case
    arr["N"] = "0123456789"                        # Numbers
    arr["P"] = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"   # Punctuation: I.E. other
    arr["A"] = arr["L"] arr["U"]                   # Alphabetic: lower and upper case
    arr["E"] = arr["L"] arr["U"] arr["N"] arr["P"] # Everything: lower, upper, number, punctuation
    arr["B"] = " "                                 # Blank: a space
# validate array index and length of assignment
    for (i in arr) {
      if (length(i) != 1) {
        error(sprintf("arr[%s], index is invalid",i))
      }
      if (length(arr[i]) == 0) {
        error(sprintf("arr[%s], is null",i))
      }
      mask_valids = sprintf("%s%s",mask_valids,i)
    }
# validate command line variables
    if (mask == "") {
      mask = "LUNP" # satisfy Rosetta Code task requirement
    }
    if (xt == "") {
      xt = 10 # default iterations
    }
    if (xt !~ /^[0-9]+$/) {
      error("xt is not 0-9")
    }
# validate each character in mask
    for (i=1; i<=length(mask); i++) {
      c = substr(mask,i,1)
      if (!(c in arr)) {
        error(sprintf("mask position %d is %s, invalid",i,c))
      }
    }
# help
    if (ARGV[1] == "?") {
      syntax()
      exit(0)
    }
    if (ARGC-1 != 0) {
      error("no files allowed on command line")
    }
# make passwords
    if (errors == 0) {
      for (i=1; i<=xt; i++) {
        make_password()
      }
    }
    exit(errors+0)
}
function error(message) {
    printf("error: %s\n",message)
    errors++
}
function make_password(  c,i,indx,password,valids) {
    for (i=1; i<=length(mask); i++) {  # for each character in mask
      c = substr(mask,i,1)             # extract 1 character from mask
      valids = arr[c]                  # valid characters for this position in mask
      indx = int(rand() * length(valids)) + 1
      c = substr(valids,indx,1)        # extract 1 character from list of valids
      password = password c            # build password
    }
    printf("%s\n",password)
}
function syntax(  cmd,i) {
    cmd = "GAWK -f PASSWORD_GENERATOR.AWK"
    printf("syntax: %s [-v mask=x] [-v xt=x]\n\n",cmd)
    printf("  mask  1..n bytes determines password format and length; consists of %s\n",mask_valids)
    for (i in arr) {
      printf("%9s - %s\n",i,(arr[i] == " ") ? "<space>" : arr[i])
    }
    printf("  xt    number of passwords to generate\n\n")
    printf("example: %s -v mask=%s -v xt=%s\n",cmd,mask,xt)
}
