DOWHOLIDAY
 ;In what years between 2008 and 2121 will December 25 be a Sunday?
 ;Uses the VA's public domain routine %DTC (Part of the Kernel) named here DIDTC
 NEW BDT,EDT,CHECK,CHKFOR,LIST,I,X,Y
 ;BDT - the beginning year to check
 ;EDT - the end year to check
 ;BDT and EDT are year offsets from the epoch date 1/1/1700
 ;CHECK - the month and day to look at
 ;CHKFOR - what day of the week to look for
 ;LIST - list of years in which the condition is true
 ;I - the year currently being checked
 ;X - the date in an "internal" format, for input to DOW^DIDTC
 ;Y - the output from DOW^DIDTC
 SET BDT=308,EDT=421,CHECK="1225",CHKFOR=0,LIST=""
 FOR I=BDT:1:EDT SET X=I_CHECK D DOW^DIDTC SET:(Y=0) LIST=$SELECT($LENGTH(LIST):LIST_", ",1:"")_(I+1700)
 IF $LENGTH(LIST)=0 WRITE !,"There are no years that have Christmas on a Sunday in the given range."
 IF $LENGTH(LIST) WRITE !,"The following years have Christmas on a Sunday: ",LIST
 KILL BDT,EDT,CHECK,CHKFOR,LIST,I,X,Y
 QUIT
