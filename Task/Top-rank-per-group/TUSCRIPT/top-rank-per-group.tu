$$ MODE TUSCRIPT
MODE DATA
$$ SET dates=*
Tyler Bennett,E10297,32000,D101
John Rappl,E21437,47000,D050
George Woltman,E00127,53500,D101
Adam Smith,E63535,18000,D202
Claire Buckman,E39876,27800,D202
David McClellan,E04242,41500,D101
Rich Holcomb,E01234,49500,D202
Nathan Adams,E41298,21900,D050
Richard Potter,E43128,15900,D101
David Motsinger,E27002,19250,D202
Tim Sampair,E03033,27000,D101
Kim Arlich,E10001,57000,D190
Timothy Grove,E16398,29900,D190
$$ MODE TUSCRIPT
SET nix=SPLIT (dates,":,:",EmployeeName,Employee_ID,Salary,Department)
SET d=MIXED_SORT (department),d=REDUCE(d)
SET index=DIGIT_INDEX(salary), index=REVERSE(index)
SET employeeName=INDEX_SORT (employeeName,index)
SET employee_ID =INDEX_SORT (employee_ID,index)
SET Salary=INDEX_SORT (salary,index)
SET Department=INDEX_SORT (Department,index)
COMPILE
LOOP l=d
PRINT "Department ", l
SET rtable=QUOTES (l)
BUILD R_TABLE pos = rtable
SET id=FILTER_INDEX (department,pos,-)
RELEASE R_TABLE pos
SET en  =SELECT (employeeName,#id)
SET ei  =SELECT (employee_ID,#id)
SET sal =SELECT (salary,#id)
SET he  =CENTER ("employeeName",-16)
SET hi  =CENTER ("employee ID",-11)
SET hs  =CENTER ("Salary",+10)
SET line=REPEAT ("-",37)
PRINT he,hi,hs
PRINT line
 LOOP e=en,i=ei,s=sal
 SET e=CENTER (e,-16), i=CENTER (i,-11), s=CENTER (s,+10)
 PRINT e,i,s
 ENDLOOP
PRINT " "
ENDLOOP
ENDCOMPILE
