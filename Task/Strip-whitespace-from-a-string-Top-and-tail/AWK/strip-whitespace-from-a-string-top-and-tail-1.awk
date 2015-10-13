function trimleft(str   ,c, out, arr) {
    c = split(str, arr, "")
    for ( i = match(str, /[[:graph:]]/); i <= c; i++)
          out = out arr[i]
    return out
}

function reverse(str    ,n, tmp, j, out) {
    n = split(str, tmp, "")
    for (j = n; j > 0; j--)
        out = out tmp[j]
    return out
}

function trimright(str) {
    return reverse(trimleft(reverse(str)))
}

function trim(str) {
    return trimright(trimleft(str))
}

BEGIN {
    str = " \x0B\t\r\n \xA0 Hellö \xA0\x0B\t\r\n "
    print "string  = |" str "|"
    print "left    = |" trimleft(str) "|"
    print "right   = |" trimright(str) "|"
    print "both    = |" trim(str) "|"
}
