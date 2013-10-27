# syntax: GAWK -f CHECK_THAT_FILE_EXISTS.AWK
BEGIN {
    check_exists("input.txt")
    check_exists("\\input.txt")
    check_exists("docs")
    check_exists("\\docs")
    exit(0)
}
function check_exists(name,  fnr,msg,rec) {
    while (getline rec <name > 0) {
      fnr++
      break
    }
    # "Permission denied" is for MS-Windows
    msg = (ERRNO == 0 || ERRNO ~ /Permission denied/ || fnr > 0) ? "exists" : "does not exist"
    printf("%s - %s\n",name,msg)
    close(name)
}
