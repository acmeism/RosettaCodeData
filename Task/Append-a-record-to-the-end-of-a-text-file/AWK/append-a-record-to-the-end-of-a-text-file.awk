# syntax: GAWK -f APPEND_A_RECORD_TO_THE_END_OF_A_TEXT_FILE.AWK
BEGIN {
    fn = "\\etc\\passwd"
# create and populate file
    print("account:password:UID:GID:fullname,office,extension,homephone,email:directory:shell") >fn
    print("jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash") >fn
    print("jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash") >fn
    close(fn)
    show_file("initial file")
# append record
    print("xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash") >>fn
    close(fn)
    show_file("file after append")
    exit(0)
}
function show_file(desc,  nr,rec) {
    printf("%s:\n",desc)
    while (getline rec <fn > 0) {
      nr++
      printf("%s\n",rec)
    }
    close(fn)
    printf("%d records\n\n",nr)
}
