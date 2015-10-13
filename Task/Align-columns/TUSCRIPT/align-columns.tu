$$ MODE TUSCRIPT
MODE DATA
$$ SET exampletext=*
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
$$ MODE TUSCRIPT
SET nix=SPLIT (exampletext,":$:",c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12)
LOOP l1=1,12
SET colum=CONCAT ("c",l1)
SET newcolum=CONCAT ("new",l1)
SET @newcolum="", length=MAX LENGTH (@colum), space=length+2
 LOOP n,l2=@colum
 SET newcell=CENTER (l2,space)
 SET @newcolum=APPEND (@newcolum,"~",newcell)
 ENDLOOP
 SET @newcolum=SPLIT  (@newcolum,":~:")
ENDLOOP
SET exampletext=JOIN(new1,"$",new2,new3,new4,new5,new6,new7,new8,new9,new10,new11,new12)
