# syntax: GAWK -f DECISION_TABLES.AWK DECISION_TABLES.TXT
BEGIN {
    FS = ":"
}
{   if ($0 ~ /^#/) { # comment
      next
    }
    if (rule_length == 0) { # 1st rule
      rule_length = length($2)
    }
    if (rule_length != length($2)) {
      error(sprintf("FILENAME=%s, FNR=%d, rule length not consistent with previous lengths, %s",FILENAME,FNR,$0))
    }
    if ($1 == "C") { # condition
      if ($2 !~ /^[NY]+$/) {
        error(sprintf("FILENAME=%s, FNR=%d, rule S/B 'N' or 'Y', %s",FILENAME,FNR,$0))
      }
      c_arr[++c] = $2 SUBSEP $3
    }
    else if ($1 == "A") { # action
      if ($2 !~ /^[X-]+$/) {
        error(sprintf("FILENAME=%s, FNR=%d, rule S/B 'X' or '-', %s",FILENAME,FNR,$0))
      }
      a_arr[++a] = $2 SUBSEP $3
    }
}
END {
    validate_rules()
    if (errors > 0) { exit(1) }
    show_actions(ask_conditions())
    exit(0)
}
function ask_conditions(  ans,i,key) {
    print("condtions:")
    for (i=1; i<=c; i++) {
      while (1) {
        printf("  %s? ",getext(c_arr[i]))
        getline ans <"con"
        if (ans ~ /^[nNyY]/) {
          key = key toupper(substr(ans,1,1))
          break
        }
      }
    }
    return(key)
}
function getext(str) {
    return(substr(str,index(str,SUBSEP)+1))
}
function show_actions(user_reply,  hits,i,key) {
    key = key_arr[user_reply]
    print("actions:")
    for (i=1; i<=a; i++) {
      if (substr(a_arr[i],key,1) == "X") {
        printf("  %s\n",getext(a_arr[i]))
        hits++
      }
    }
    printf("%d found\n",hits)
}
function validate_rules(  i,j,key) {
    for (i=1; i<=rule_length; i++) {
      key = ""
      for (j=1; j<=c; j++) {
        key = key substr(c_arr[j],i,1)
      }
      if (key in key_arr) {
        error(sprintf("duplicate key: %s",key))
      }
      key_arr[key] = i
    }
}
function error(message) {
    printf("error: %s\n",message)
    errors++
    return
}
