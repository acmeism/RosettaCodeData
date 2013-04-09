#!/usr/bin/awk -f

BEGIN {
    message = "My hovercraft is full of eels."
    key = 1

    cypher = caesarEncode(key, message)
    clear  = caesarDecode(key, cypher)

    print "message: " message
    print " cypher: " cypher
    print "  clear: " clear
    exit
}

function caesarEncode(key, message) {
    return caesarXlat(key, message, "encode")
}

function caesarDecode(key, message) {
    return caesarXlat(key, message, "decode")
}

function caesarXlat(key, message, dir,    plain, cypher, i, num, s) {
    plain = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    cypher = substr(plain, key+1) substr(plain, 1, key)

    if (toupper(substr(dir, 1, 1)) == "D") {
        s = plain
        plain = cypher
        cypher = s
    }

    s = ""
    message = toupper(message)
    for (i = 1; i <= length(message); i++) {
        num = index(plain, substr(message, i, 1))
        if (num) s = s substr(cypher, num, 1)
        else s = s substr(message, i, 1)
    }
    return s
}
