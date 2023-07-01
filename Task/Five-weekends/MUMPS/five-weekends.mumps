FIVE
 ;List and count the months between 1/1900 and 12/2100 that have 5 full weekends
 ;Extra credit - list and count years with no months with five full weekends
 ;Using the test that the 31st of a month is on a Sunday
 ;Uses the VA's public domain routine %DTC (Part of the Kernel) named here DIDTC
 NEW YEAR,MONTH,X,Y,CNTMON,NOT,NOTLIST
 ; YEAR is the year we're testing
 ; MONTH is the month we're testing
 ; X is the date in "internal" format, as an input to DOW^DIDTC
 ; Y is the day of the week (0=Sunday, 1=Monday...) output from DOW^DIDTC
 ; CNTMON is a count of the months that have 5 full weekends
 ; NOT is a flag if there were no months with 5 full weekends yet that year
 ; NOTLIST is a list of years that do not have any months with 5 full weekends
 SET CNTMON=0,NOTLIST=""
 WRITE !!,"The following months have five full weekends:"
 FOR YEAR=200:1:400 DO ;years since 12/31/1700 epoch
 . SET NOT=0
 . FOR MONTH="01","03","05","07","08","10","12" DO
 . . SET X=YEAR_MONTH_"31"
 . . DO DOW^DIDTC
 . . IF (Y=0) DO
 . . . SET NOT=NOT+1,CNTMON=CNTMON+1
 . . . WRITE !,MONTH_"-"_(YEAR+1700)
 . SET:(NOT=0) NOTLIST=NOTLIST_$SELECT($LENGTH(NOTLIST)>1:",",1:"")_(YEAR+1700)
 WRITE !,"For a total of "_CNTMON_" months."
 WRITE !!,"There are "_$LENGTH(NOTLIST,",")_" years with no five full weekends in any month."
 WRITE !,"They are: "_NOTLIST
 KILL YEAR,MONTH,X,Y,CNTMON,NOT,NOTLIST
 QUIT
F ;Same logic as the main entry point, shortened format
 N R,M,X,Y,C,N,L S C=0,L=""
 W !!,"The following months have five full weekends:"
 F R=200:1:400 D
 . S N=0 F M="01","03","05","07","08","10","12" S X=R_M_"31" D DOW^DIDTC I 'Y S N=N+1,C=C+1 W !,M_"-"_(R+1700)
 . S:'N L=L_$S($L(L):",",1:"")_(R+1700)
 W !,"For a total of "_C_" months.",!!,"There are "_$L(L,",")_" years with no five full weekends in any month.",!,"They are: "_L
 Q
