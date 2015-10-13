@load "filefuncs"
BEGIN {
    printsize("input.txt")
    printsize("/input.txt")
}
function printsize(name         ,fd) {
    stat(name, fd)
    printf("%s\t%s\n", name, fd["size"])
}
