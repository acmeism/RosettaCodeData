# syntax: GAWK -f WRITE_TO_WINDOWS_EVENT_LOG.AWK
BEGIN {
    write("INFORMATION",1,"Rosetta Code")
    exit (errors == 0) ? 0 : 1
}
function write(type,id,description,  cmd,esf) {
    esf = errors # errors so far
    cmd = sprintf("EVENTCREATE.EXE /T %s /ID %d /D \"%s\" >NUL",type,id,description)
    printf("%s\n",cmd)
    if (toupper(type) !~ /^(SUCCESS|ERROR|WARNING|INFORMATION)$/) { error("/T is invalid") }
    if (id+0 < 1 || id+0 > 1000) { error("/ID is invalid") }
    if (description == "") { error("/D is invalid") }
    if (errors == esf) {
      system(cmd)
    }
    return(errors)
}
function error(message) { printf("error: %s\n",message) ; errors++ }
