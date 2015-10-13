@load "filefuncs"
BEGIN {

    name = "input.txt"

    # display time
    stat(name, fd)
    printf("%s\t%s\n", name, strftime("%a %b %e %H:%M:%S %Z %Y", fd["mtime"]) )

    # change time
    cmd = "touch -t 201409082359.59 " name
    system(cmd)
    close(cmd)

}
