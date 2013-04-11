/*REXX program to process  instrument data  from a  data file.          */
numeric digits 20                      /*allow for bigger numbers.      */
ifid='READINGS.TXT'                    /*the  input  file.              */
ofid='READINGS.OUT'                    /*the  outut  file.              */
grandSum=0                             /*grand sum of whole file.       */
grandflg=0                             /*grand num of flagged data.     */
grandOKs=0
longFlag=0                             /*longest period of flagged data.*/
contFlag=0                             /*longest continous flagged data.*/
oldDate =0                             /*placeholder of penutilmate date*/
w       =16                            /*width of fields when displayed.*/
dupDates=0                             /*count of duplicated timestamps.*/
badflags=0                             /*count of bad flags (¬ integer).*/
badDates=0                             /*count of bad dates (bad format)*/
badData =0                             /*count of bad datas (¬ numeric).*/
ignoredR=0                             /*count of ignored records (bad).*/
maxInstruments=24                      /*maximum number of instruments. */
yyyyCurr=right(date(),4)               /*get the current year (today).  */
monDD.  =31                            /*number of days in every month. */
                                       /*February is figured on the fly.*/
monDD.4 =30
monDD.6 =30
monDD.9 =30
monDD.11=30

  do records=1  while lines(ifid)\==0  /*read until finished.           */
  rec=linein(ifid)                     /*read the next record (line).   */
  parse var rec datestamp Idata        /*pick off the dateStamp & data. */
  if datestamp==oldDate then do        /*found a duplicate timestamp.   */
                             dupDates=dupDates+1     /*bump the counter.*/
                             call sy datestamp copies('~',30),
                                      'is a duplicate of the',
                                      "previous datestamp."
                             ignoredR=ignoredR+1     /*bump ignoredRecs.*/
                             iterate   /*ignore this duplicate record.  */
                             end

  parse var datestamp yyyy '-' mm '-' dd   /*obtain YYYY, MM, and DD.   */
  monDD.2=28+leapyear(yyyy)            /*how long is February in YYYY ? */
                                       /*check for various bad formats. */
  if verify(yyyy||mm||dd,1234567890)\==0 |,
     length(datestamp)\==10   |,
     length(yyyy)\==4         |,
     length(mm  )\==2         |,
     length(dd  )\==2         |,
     yyyy<1970                |,
     yyyy>yyyyCurr            |,
     mm=0   | dd=0            |,
     mm>12  | dd>monDD.mm then do
                               badDates=badDates+1
                               call sy datestamp copies('~'),
                                                 'has an illegal format.'
                               ignoredR=ignoredR+1   /*bump ignoredRecs.*/
                               iterate   /*ignore this bad date record. */
                               end
  oldDate=datestamp                    /*save datestamp for next read.  */
  sum=0
  flg=0
  OKs=0

    do j=1  until Idata=''             /*process the instrument data.  */
    parse var Idata data.j flag.j Idata

    if pos('.',flag.j)\==0 |,          /*flag have a decimal point  -or-*/
       \datatype(flag.j,'W') then do   /*is the flag not a whole number?*/
                                  badflags=badflags+1    /*bump counter.*/
                                  call sy datestamp copies('~'),
                                          'instrument' j "has a bad flag:",
                                          flag.j
                                  iterate       /*ignore it & it's data.*/
                                  end

    if \datatype(data.j,'N') then do   /*is the flag not a whole number?*/
                                  badData=badData+1      /*bump counter.*/
                                  call sy datestamp copies('~'),
                                          'instrument' j "has bad data:",
                                          data.j
                                  iterate       /*ignore it & it's flag.*/
                                  end

    if flag.j>0 then do                /*if good data, ...              */
                     OKs=OKs+1
                     sum=sum+data.j
                     if contFlag>longFlag then do
                                               longdate=datestamp
                                               longFlag=contFlag
                                               end
                     contFlag=0
                     end
                else do                /*flagged data ...               */
                     flg=flg+1
                     contFlag=contFlag+1
                     end
    end   /*j*/

  if j>maxInstruments then do
                           badData=badData+1             /*bump counter.*/
                           call sy datestamp copies('~'),
                                   'too many instrument datum'
                           end

  if OKs\==0 then avg=format(sum/OKs,,3)
             else avg='[n/a]'
  grandOKs=grandOKs+OKs
  _=right(comma(avg),w)
  grandSum=grandSum+sum
  grandFlg=grandFlg+flg
  if flg==0  then  call sy datestamp ' average='_
             else  call sy datestamp ' average='_ '  flagged='right(flg,2)
  end   /*records*/

records=records-1                      /*adjust for reading end-of-file.*/
if grandOKs\==0 then grandAvg=format(grandsum/grandOKs,,3)
                else grandAvg='[n/a]'
call sy
call sy copies('=',60)
call sy '      records read:' right(comma(records ),w)
call sy '   records ignored:' right(comma(ignoredR),w)
call sy '     grand     sum:' right(comma(grandSum),w+4)
call sy '     grand average:' right(comma(grandAvg),w+4)
call sy '     grand OK data:' right(comma(grandOKs),w)
call sy '     grand flagged:' right(comma(grandFlg),w)
call sy '   duplicate dates:' right(comma(dupDates),w)
call sy '         bad dates:' right(comma(badDates),w)
call sy '         bad  data:' right(comma(badData ),w)
call sy '         bad flags:' right(comma(badflags),w)
if longFlag\==0 then
call sy '   longest flagged:' right(comma(longFlag),w) " ending at " longdate
call sy copies('=',60)
call sy
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LEAPYEAR subroutine─────────────────*/
leapyear: procedure; arg y             /*year could be: Y, YY, YYY, YYYY*/
if length(y)==2 then y=left(right(date(),4),2)y    /*adjust for YY year.*/
if y//4\==0     then return 0          /* not ≈ by 4?    Not a leapyear.*/
return y//100\==0 | y//400==0          /*apply 100 and 400 year rule.   */
/*──────────────────────────────────SY subroutine───────────────────────*/
sy: procedure; parse arg stuff;   say stuff
    if  1==0  then call lineout ofid,stuff
    return
/*──────────────────────────────────COMMA subroutine────────────────────*/
comma: procedure; parse arg _,c,p,t;arg ,cu;c=word(c ",",1)
       if cu=='BLANK' then c=' ';o=word(p 3,1);p=abs(o);t=word(t 999999999,1)
       if \datatype(p,'W')|\datatype(t,'W')|p==0|arg()>4 then return _;n=_'.9'
       #=123456789;k=0;if o<0 then do;b=verify(_,' ');if b==0 then return _
       e=length(_)-verify(reverse(_),' ')+1;end;else do;b=verify(n,#,"M")
       e=verify(n,#'0',,verify(n,#"0.",'M'))-p-1;end
       do j=e to b by -p while k<t;_=insert(c,_,j);k=k+1;end;return _
