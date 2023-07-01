# syntax: GAWK -f EMPTY_DIRECTORY.AWK
BEGIN {
    n = split("C:\\TEMP3,C:\\NOTHERE,C:\\AWK\\FILENAME,C:\\WINDOWS",arr,",")
    for (i=1; i<=n; i++) {
      printf("'%s' %s\n",arr[i],is_dir(arr[i]))
    }
    exit(0)
}
function is_dir(path,  cmd,dots,entries,msg,rec,valid_dir) {
    cmd = sprintf("DIR %s 2>NUL",path) # MS-Windows
    while ((cmd | getline rec) > 0) {
      if (rec ~ /[0-9]:[0-5][0-9]/) {
        if (rec ~ / (\.|\.\.)$/) { # . or ..
          dots++
          continue
        }
        entries++
      }
      if (rec ~ / Dir\(s\) .* bytes free$/) {
        valid_dir = 1
      }
    }
    close(cmd)
    if (valid_dir == 0) {
      msg = "does not exist"
    }
    else if (valid_dir == 1 && entries == 0) {
      msg = "is an empty directory"
    }
    else if (dots == 0 && entries == 1) {
      msg = "is a file"
    }
    else {
      msg = sprintf("is a directory with %d entries",entries)
    }
    return(msg)
}
