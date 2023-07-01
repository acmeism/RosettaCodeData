total = 10000
swapper = 0
sticker = 0
revealdoor = 0
for trial = 1 to total
    prizedoor = random(3) + 1
    guessdoor = random(3) + 1
    if prizedoor = guessdoor
       revealdoor = random(2) + 1
       if prizedoor = 1 revealdoor += 1 ok
       if (prizedoor = 2 and revealdoor = 2) revealdoor = 3 ok
    else
       revealdoor = (prizedoor ^ guessdoor)
    ok
    stickdoor = guessdoor
    swapdoor = (guessdoor ^ revealdoor)
    if stickdoor = prizedoor sticker += 1 ok
    if swapdoor = prizedoor swapper += 1 ok
next
see "after a total of " + total + " trials," + nl
see "the 'sticker' won " + sticker + " times (" + floor(sticker/total*100) + "%)" + nl
see "the 'swapper' won " + swapper + " times (" + floor(swapper/total*100) + "%)" + nl
