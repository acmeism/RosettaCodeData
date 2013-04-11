$$ MODE TUSCRIPT
text="THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"
PRINT "text orginal    ",text

abc="ABCDEFGHIJKLMNOPQRSTUVWXYZ",key=3,caesarskey=key+1
secretbeg=EXTRACT (abc,#caesarskey,0)
secretend=EXTRACT (abc,0,#caesarskey)
secretabc=CONCAT (secretbeg,secretend)

abc=STRINGS (abc,":</:"),secretabc=STRINGS (secretabc,":</:")
abc=SPLIT (abc),         secretabc=SPLIT (secretabc)
abc2secret=JOIN(abc," ",secretabc),secret2abc=JOIN(secretabc," ",abc)

BUILD X_TABLE abc2secret=*
DATA  {abc2secret}

BUILD X_TABLE secret2abc=*
DATA  {secret2abc}

ENCODED = EXCHANGE (text,abc2secret)
PRINT "text encoded    ",encoded

DECODED = EXCHANGE (encoded,secret2abc)
PRINT "encoded decoded ",decoded
