splitNum=: {. ,&(_&".) }.
allSplits=: (i.&.<:@# splitNum"0 1 ])@":
sumValidSplits=: +/"1@:(#~ 0 -.@e."1 ])
filterKaprekar=: #~ ] e."0 1 [: sumValidSplits@allSplits"0 *:
