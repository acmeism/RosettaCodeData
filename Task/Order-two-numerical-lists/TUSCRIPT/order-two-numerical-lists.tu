$$ MODE TUSCRIPT
MODE DATA
$$ numlists=*
1'2'1'3'2
1'2'0'4'4'0'0'0
1'2'3'4'5
1'2'1'5'2'2
1'2'1'6
1'2'1'6'2
1'2'4
1'2'4
1'2
1'2'4
$$ MODE TUSCRIPT
list1="1'2'5'6'7"
LOOP n,list2=numlists
text=CONCAT (" ",list1," < ",list2)
IF (list1<list2) THEN
PRINT " true: ",text
ELSE
PRINT "false: ",text
ENDIF
list1=VALUE(list2)
ENDLOOP
