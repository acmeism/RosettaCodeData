# syntax: GAWK -f TRUNCATE_A_FILE.AWK
BEGIN {
    main("NOTHERE",100)
    main("FILENAME.TMP",-1)
    main("FILENAME.TMP",500)
    exit(0)
}
function main(filename,size,  ret) {
    ret = truncate_file(filename,size)
    if (ret != "") {
      printf("error: FILENAME=%s, %s\n",filename,ret)
    }
}
function truncate_file(filename,size,  cmd,fnr,msg,old_BINMODE,old_RS,rec) {
    cmd = sprintf("ls --full-time -o %s",filename)
    if (size < 0) {
      return("size cannot be negative")
    }
    old_BINMODE = BINMODE
    old_RS = RS
    BINMODE = 3
    RS = "[^\x00-\xFF]"
    while (getline rec <filename > 0) {
      fnr++
    }
    close(filename)
    if (fnr == 0) {
      msg = "file not found"
    }
    if (fnr > 1) {
      msg = "choose a different RecordSeparator"
    }
    if (msg == "") { # no errors
      system(cmd) # optional: show filesize before truncation
      if (length(rec) > size) {
        rec = substr(rec,1,size)
      }
      printf("%s",rec) >filename
      close(filename)
      system(cmd) # optional: show filesize after truncation
    }
    BINMODE = old_BINMODE
    RS = old_RS
    return(msg)
}
