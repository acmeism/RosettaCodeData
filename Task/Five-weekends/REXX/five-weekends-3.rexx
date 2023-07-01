/* REXX ***************************************************************
* Short(er) solution focussed at the task's description
* Only 7 months can have 5 full weekends
* and it's enough to test if the 1st day of the month is a Friday
* 30.08.2012 Walter Pachl
**********************************************************************/
Numeric digits 20
nr5fwe=0
years_without_5fwe=0
mnl='Jan Mar May Jul Aug Oct Dec'
ml='1 3 5 7 8 10 12'
Do j=1900 to 2100
  year_has_5fwe=0
  Do mi=1 To words(ml)
    m=word(ml,mi)
    jd=greg2jul(j m 1)
    IF jd//7=4 Then Do              /* 1st m j is a Friday */
      nr5fwe=nr5fwe+1
      year_has_5fwe=1
      If j<=1905 | 2095<=j Then
        Say word(mnl,mi) j 'has 5 full weekends'
      End
    End
    If j=1905 Then Say '...'
    if year_has_5fwe=0 Then years_without_5fwe=years_without_5fwe+1
  End
Say ' '
Say nr5fwe 'occurrences of 5 full weekends in a month'
Say years_without_5fwe 'years without 5 full weekends'
exit

greg2jul: Procedure
/***********************************************************************
* Converts a Gregorian date to the corresponding Julian day number
* 19891101 Walter Pachl REXXified algorithm published in CACM
*                (Fliegel & vanFlandern, CACM Vol.11 No.10 October 1968)
* 19891125 PA copy leapyear test into this to avoid the dependency
***********************************************************************/
  numeric digits 12
  Parse Arg yy mm d
  If mm<1 | 12<mm Then Call err 'month ('mm') not within 1 to 12'
  mdl='31' (28+leapyear(yy)) '31 30 31 30 31 31 30 31 30 31'
  md=word(mdl,mm)
  If d<1 | md<d  Then Call err 'day ('d') not within 1 to' md
/***********************************************************************
* The published formula:
* res=d-32075+1461*(yy+4800+(mm-14)%12)%4+,
*     367*(mm-2-((mm-14)%12)*12)%12-3*((yy+4900+(mm-14)%12)%100)%4
***********************************************************************/
  mma=(mm-14)%12
  yya=yy+4800+mma
  result=d-32075+1461*yya%4+367*(mm-2-mma*12)%12-3*((yya+100)%100)%4
    Return result                   /* return the result              */

leapyear: Return ( (arg(1)//4=0) & (arg(1)//100<>0) ) | (arg(1)//400=0)
