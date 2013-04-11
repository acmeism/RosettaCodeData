$$ MODE TUSCRIPT,{}
var1=1, var2="b"
PRINT "var1=",var1
PRINT "var2=",var2

basket=*
DATA apples
DATA bananas
DATA cherry

LOOP n,letter="a'b'c",fruit=basket
var=CONCAT (letter,n)
SET @var=VALUE(fruit)
PRINT var,"=",@var
ENDLOOP
