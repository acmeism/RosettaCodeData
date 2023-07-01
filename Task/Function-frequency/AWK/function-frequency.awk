# syntax: GAWK -f FUNCTION_FREQUENCY.AWK filename(s).AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
# create array of keywords to be ignored by lexer
    asplit("BEGIN:END:atan2:break:close:continue:cos:delete:" \
           "do:else:exit:exp:for:getline:gsub:if:in:index:int:"  \
           "length:log:match:next:print:printf:rand:return:sin:" \
           "split:sprintf:sqrt:srand:strftime:sub:substr:system:tolower:toupper:while",
           keywords,":")
# build the symbol-state table
    split("00:00:00:00:00:00:00:00:00:00:" \
          "20:10:10:12:12:11:07:00:00:00:" \
          "08:08:08:08:08:33:08:00:00:00:" \
          "08:44:08:36:08:08:08:00:00:00:" \
          "08:44:45:42:42:41:08",machine,":")
# parse the input
    state = 1
    for (;;) {
      symb = lex() # get next symbol
      nextstate = substr(machine[state symb],1,1)
      act = substr(machine[state symb],2,1)
      # perform required action
      if (act == "0") { # do nothing
      }
      else if (act == "1") { # found a function call
        if (!(inarray(tok,names))) {
          names[++nnames] = tok
        }
        ++xnames[tok]
      }
      else if (act == "2") { # found a variable or array
        if (tok in Local) {
          tok = tok "(" funcname ")"
          if (!(inarray(tok,names))) {
            names[++nnames] = tok
          }
          ++xnames[tok]
        }
        else {
          tok = tok "()"
          if (!(inarray(tok,names))) {
            names[++nnames] = tok
          }
          ++xnames[tok]
        }
      }
      else if (act == "3") { # found a function definition
        funcname = tok
      }
      else if (act == "4") { # found a left brace
        braces++
      }
      else if (act == "5") { # found a right brace
        braces--
        if (braces == 0) {
          delete Local
          funcname = ""
          nextstate = 1
        }
      }
      else if (act == "6") { # found a local variable declaration
        Local[tok] = 1
      }
      else if (act == "7") { # found end of file
        break
      }
      else if (act == "8") { # found an error
        printf("error: FILENAME=%s, FNR=%d\n",FILENAME,FNR)
        exit(1)
      }
      state = nextstate # finished with current token
    }
# format function names
    for (i=1; i<=nnames; i++) {
      if (index(names[i],"(") == 0) {
        tmp_arr[xnames[names[i]]][names[i]] = ""
      }
    }
# print function names
    PROCINFO["sorted_in"] = "@ind_num_desc" ; SORTTYPE = 9
    for (i in tmp_arr) {
      PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
      for (j in tmp_arr[i]) {
        if (++shown <= 10) {
          printf("%d %s\n",i,j)
        }
      }
    }
    exit(0)
}
function asplit(str,arr,fs,  i,n,temp_asplit) {
    n = split(str,temp_asplit,fs)
    for (i=1; i<=n; i++) {
      arr[temp_asplit[i]]++
    }
}
function inarray(val,arr,  j) {
    for (j in arr) {
      if (arr[j] == val) {
        return(j)
      }
    }
    return("")
}
function lex() {
    for (;;) {
      if (tok == "(eof)") {
        return(7)
      }
      while (length(line) == 0) {
        if (getline line == 0) {
          tok = "(eof)"
          return(7)
        }
      }
      sub(/^[ \t]+/,"",line)           # remove white space,
      sub(/^"([^"]|\\")*"/,"",line)    # quoted strings,
      sub(/^\/([^\/]|\\\/)+\//,"",line) # regular expressions,
      sub(/^#.*/,"",line)              # and comments
      if (line ~ /^function /) {
        tok = "function"
        line = substr(line,10)
        return(1)
      }
      else if (line ~ /^{/) {
        tok = "{"
        line = substr(line,2)
        return(2)
      }
      else if (line ~ /^}/) {
        tok = "}"
        line = substr(line,2)
        return(3)
      }
      else if (match(line,/^[A-Za-z_][A-Za-z_0-9]*\[/)) {
        tok = substr(line,1,RLENGTH-1)
        line = substr(line,RLENGTH+1)
        return(5)
      }
      else if (match(line,/^[A-Za-z_][A-Za-z_0-9]*\(/)) {
        tok = substr(line,1,RLENGTH-1)
        line = substr(line,RLENGTH+1)
        if (!(tok in keywords)) { return(6) }
      }
      else if (match(line,/^[A-Za-z_][A-Za-z_0-9]*/)) {
        tok = substr(line,1,RLENGTH)
        line = substr(line,RLENGTH+1)
        if (!(tok in keywords)) { return(4) }
      }
      else {
        match(line,/^[^A-Za-z_{}]/)
        tok = substr(line,1,RLENGTH)
        line = substr(line,RLENGTH+1)
      }
    }
}
