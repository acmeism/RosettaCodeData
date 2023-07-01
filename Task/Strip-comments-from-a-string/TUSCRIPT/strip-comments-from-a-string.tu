$$ MODE TUSCRIPT
strngcomment=*
DATA apples, pears # and bananas
DATA apples, pears ; and bananas

BUILD S_TABLE comment_char="|#|;|"

LOOP s=strngcomment
x=SPLIT (s,comment_char,string,comment)
PRINT string
ENDLOOP
