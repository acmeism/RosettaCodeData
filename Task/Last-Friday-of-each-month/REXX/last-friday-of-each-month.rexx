/*REXX program displays the dates of the  last Fridays of each month for any given year.*/
parse arg yyyy
                 do j=1  for 12
                 say lastDOW('Friday', j, yyyy)  /*find last Friday for the  Jth  month.*/
                 end  /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
lastDOW: procedure;  arg dow .,mm .,yy .;     parse arg a.1,a.2,a.3  /*DOW = day of week*/
if mm=='' | mm=='*'  then mm=left( date('U'), 2)                     /*use default month*/
if yy=='' | yy=='*'  then yy=left( date('S'), 4)                     /*use default year */
if length(yy)==2     then yy=left( date('S'), 2)yy                   /*append century.  */
                                         /*Note mandatory leading blank in strings below*/
$=" Monday TUesday Wednesday THursday Friday SAturday SUnday"
!=" JAnuary February MARch APril MAY JUNe JULy AUgust September October November December"
upper $ !                                                            /*uppercase strings*/
if dow==''                 then call .er "wasn't specified",1
if arg()>3                 then call .er 'arguments specified',4

  do j=1  for 3                                                      /*any plural args ?*/
  if words(arg(j))>1       then call .er 'is illegal:',j
  end

dw=pos(' 'dow,$)                                                     /*find  day-of-week*/
if dw==0                   then call .er 'is invalid:',1
if dw\==lastpos(' 'dow,$)  then call .er 'is ambigious:',1

if datatype(mm,'M')  then                                            /*is MM alphabetic?*/
  do
  m=pos(' 'mm,!)                                                     /*maybe its good...*/
  if m==0                  then call .er 'is invalid:',1
  if m\==lastpos(' 'mm,!)  then call .er 'is ambigious:',2
  mm=wordpos( word( substr(!, m), 1), !) - 1                         /*now, use true Mon*/
  end

if \datatype(mm,'W')       then call .er "isn't an integer:",2
if \datatype(yy,'W')       then call .er "isn't an integer:",3
if mm<1 | mm>12            then call .er "isn't in range 1──►12:",2
if yy=0                    then call .er "can't be 0 (zero):",3
if yy<0                    then call .er "can't be negative:",3
if yy>9999                 then call .er "can't be > 9999:",3

tdow=wordpos(word(substr($,dw),1),$)-1                               /*target DOW, 0──►6*/
                                                                     /*day# of last dom.*/
_=date('B',right(yy+(mm=12),4)right(mm//12+1,2,0)"01",'S')-1
?=_ // 7                                                             /*calc. DOW,  0──►6*/
if ?\==tdow  then _=_ - ? - 7 + tdow + 7 * (?>tdow)                  /*not DOW?  Adjust.*/
return date('weekday', _, "B")    date(, _, 'B')                     /*return the answer*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
.er: arg ,_;  say;   say '***error*** (in LASTDOW)';   say           /*tell error,  and */
     say word('day-of-week month year excess',arg(2)) arg(1) a._
     say;     exit 13                                                /*... then exit.   */
