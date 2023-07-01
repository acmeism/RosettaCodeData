# Project : One-dimensional cellular automata

rule = ["0", "0", "0", "1", "0", "1", "1", "0"]
now = "01110110101010100100"

for generation = 0 to 9
    see "generation " + generation + ": " + now + nl
    nxt = ""
    for cell = 1 to len(now)
        str = "bintodec(" + '"' +substr("0"+now+"0", cell, 3) + '"' + ")"
        eval("p=" + str)
        nxt = nxt + rule[p+1]
    next
    temp = nxt
    nxt = now
    now = temp
next

func bintodec(bin)
     binsum = 0
     for n=1  to len(bin)
         binsum = binsum + number(bin[n]) *pow(2, len(bin)-n)
     next
     return binsum
