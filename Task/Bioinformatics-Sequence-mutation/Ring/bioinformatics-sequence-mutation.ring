row = 0
dnaList = []
base = ["A","C","G","T"]
long = 20
see "Initial sequence:" + nl
see "     12345678901234567890" + nl
see " " + long + ": "

for nr = 1 to 200
    row = row + 1
    rnd = random(3)+1
    baseStr = base[rnd]
    see baseStr # + " "
    if (row%20) = 0 and long < 200
        long = long + 20
        see nl
        if long < 100
           see " " + long + ": "
        else
           see "" + long + ": "
        ok
    ok
    add(dnaList,baseStr)
next
see nl+ "     12345678901234567890" + nl

baseCount(dnaList)

for n = 1 to 10
    rnd = random(2)+1
    switch rnd
           on 1
              baseSwap(dnaList)
           on 2
              baseDelete(dnaList)
           on 3
              baseInsert(dnaList)
    off
next
showDna(dnaList)
baseCount(dnaList)

func baseInsert(dnaList)
     rnd1 = random(len(dnaList)-1)+1
     rnd2 = random(len(base)-1)+1
     insert(dnaList,rnd1,base[rnd2])
     see "Insert base " + base[rnd2] + " at position " + rnd1 + nl
     return dnaList

func baseDelete(dnaList)
     rnd = random(len(dnaList)-1)+1
     del(dnaList,rnd)
     see "Erase base " + dnaList[rnd] + " at position " + rnd + nl
     return dnaList

func baseSwap(dnaList)
     rnd1 = random(len(dnaList))
     rnd2 = random(3)+1
     see "Change base at position " + rnd1 + " from " + dnaList[rnd1] + " to " + base[rnd2] + nl
     dnaList[rnd1] = base[rnd2]

func showDna(dnaList)
     long = 20
     see nl + "After 10 mutations:" + nl
     see "     12345678901234567890" + nl
     see " " + long + ": "
     for nr = 1 to len(dnaList)
         row = row + 1
         see dnaList[nr]
         if (row%20) = 0 and long < 200
             long = long + 20
             see nl
             if long < 100
                see " " + long + ": "
             else
                see "" + long + ": "
             ok
         ok
     next
     see nl+ "     12345678901234567890" + nl

func baseCount(dnaList)
     dnaBase = [:A=0, :C=0, :G=0, :T=0]
     lenDna = len(dnaList)
     for n = 1 to lenDna
         dnaStr = dnaList[n]
         switch dnaStr
                on "A"
                   strA = dnaBase["A"]
                   strA++
                   dnaBase["A"] = strA
                on "C"
                   strC = dnaBase["C"]
                   strC++
                   dnaBase["C"] = strC
                on "G"
                   strG = dnaBase["G"]
                   strG++
                   dnaBase["G"] = strG
                on "T"
                   strT = dnaBase["T"]
                   strT++
                   dnaBase["T"] = strT
         off
     next
     see nl
     see "A: " + dnaBase["A"] + ", "
     see "T: " + dnaBase["T"] + ", "
     see "C: " + dnaBase["C"] + ", "
     see "G: " + dnaBase["G"] + ", "
     total = dnaBase["A"] + dnaBase["T"] + dnaBase["C"] + dnaBase["G"]
     see "Total: " + total+ nl + nl
