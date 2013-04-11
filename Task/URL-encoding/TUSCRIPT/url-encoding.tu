$$ MODE TUSCRIPT
text="http://foo bar/"
BUILD S_TABLE spez_char="::>/:</::<%:"
spez_char=STRINGS (text,spez_char)
LOOP/CLEAR c=spez_char
c=ENCODE(c,hex),c=concat("%",c),spez_char=APPEND(spez_char,c)
ENDLOOP
url_encoded=SUBSTITUTE(text,spez_char,0,0,spez_char)
print "text:    ", text
PRINT "encoded: ", url_encoded
