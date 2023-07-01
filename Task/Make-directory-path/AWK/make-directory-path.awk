# syntax: GAWK -f MAKE_DIRECTORY_PATH.AWK path ...
BEGIN {
    for (i=1; i<=ARGC-1; i++) {
      path = ARGV[i]
      msg = (make_dir_path(path) == 0) ? "created" : "exists"
      printf("'%s' %s\n",path,msg)
    }
    exit(0)
}
function make_dir_path(path,  cmd) {
#   cmd = sprintf("mkdir -p '%s'",path) # Unix
    cmd = sprintf("MKDIR \"%s\" 2>NUL",path) # MS-Windows
    return system(cmd)
}
