$$ MODE TUSCRIPT
url_encoded="http%3A%2F%2Ffoo%20bar%2F"
BUILD S_TABLE hex=":%><:><2<>2<%:"
hex=STRINGS (url_encoded,hex), hex=SPLIT(hex)
hex=DECODE (hex,hex)
url_decoded=SUBSTITUTE(url_encoded,":%><2<>2<%:",0,0,hex)
PRINT "encoded: ", url_encoded
PRINT "decoded: ", url_decoded
