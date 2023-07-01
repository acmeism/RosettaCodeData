# Project : Rep-string

test = ["1001110011",
        "1110111011",
        "0010010010",
        "1010101010",
        "1111111111",
        "0100101101",
        "0100100",
        "101",
        "11",
        "00",
        "1"]

for n = 1 to len(test)
    strend = ""
    for m=1 to len(test[n])
        strbegin = substr(test[n], 1, m)
        strcut = right(test[n], len(test[n]) - m)
        nr = substr(strcut, strbegin)
        if nr=1 and len(test[n]) > 1
           strend = strbegin
        ok
    next
    if strend = ""
       see "" + test[n] + " -> (none)" + nl
    else
       see "" + test[n] + " -> " + strend + nl
    ok
next
