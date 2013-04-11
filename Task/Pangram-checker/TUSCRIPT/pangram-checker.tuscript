$$ MODE TUSCRIPT,{}
alfabet="abcdefghijklmnopqrstuvwxyz"
sentences = *
DATA The quick brown fox jumps over the lazy dog
DATA the quick brown fox falls over the lazy dog
LOOP s=sentences
 getchars      =STRINGS    (s," {&a} ")
 sortchars     =ALPHA_SORT (getchars)
 reducechars   =REDUCE     (sortchars)
 chars_in_s    =EXCHANGE   (reducechars," '  ")
 IF (chars_in_s==alfabet) PRINT "   pangram: ",s
 IF (chars_in_s!=alfabet) PRINT "no pangram: ",s
ENDLOOP
