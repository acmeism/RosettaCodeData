$$ MODE TUSCRIPT

SECTION gen_brackets
values="[']",brackets=""
LOOP n=1,12
 brackets=APPEND (brackets,"","~")
 LOOP m=1,n
 a=RANDOM_NUMBERS (1,2,1),br=SELECT(values,#a)
 brackets=APPEND(brackets,"",br)
 b=RANDOM_NUMBERS (1,2,1),br=SELECT(values,#b)
 brackets=APPEND(brackets,"",br)
 ENDLOOP
ENDLOOP
brackets=SPLIT (brackets,":~:")
ENDSECTION

MODE DATA
$$ BUILD X_TABLE brackets=*
 [[[[ (4 ]]]] )4
 [[[ (3 ]]] )3
 [[ (2 ]] )2
 [ (1 ] )1

$$ MODE TUSCRIPT
DO gen_brackets
LOOP b=brackets
status=CHECK_BRACKETS (b,brackets,a1,e1,a2,e2)
PRINT b," ",status
ENDLOOP
