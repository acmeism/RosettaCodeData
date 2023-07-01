# syntax: GAWK -f KEYBOARD_INPUT_OBTAIN_A_Y_OR_N_RESPONSE.AWK
BEGIN {
    printf("you entered %s\n",prompt_user())
    exit(0)
}
function prompt_user(  rec) {
# AWK lacks the ability to get keyboard input without pressing the enter key.
    while (1) {
      printf("enter Y or N ")
      getline rec <"con"
      gsub(/ /,"",rec) # optional
      if (rec ~ /^[nyNY]$/) {
        break
      }
    }
    return(rec)
}
