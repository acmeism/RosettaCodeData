@load "filefuncs"

function exists(name    ,fd) {
    if ( stat(name, fd) == -1)
      print name " doesn't exist"
    else
      print name " exists"
}
BEGIN {
    exists("input.txt")
    exists("/input.txt")
    exists("docs")
    exists("/docs")
}
