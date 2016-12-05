@load "filefuncs"
function filesize(name         ,fd) {
    if ( stat(name, fd) == -1)
      return -1  # doesn't exist
    else
      return fd["size"]
}
BEGIN {
    print filesize("input.txt")
    print filesize("/input.txt")
}
