/*REXX program to process instrument data from a data file. */

numeric digits 20                      /*allow for bigger numbers.      */
ifid='LICENSE.LOG'                     /*the  input  file.              */
ofid='LICENSE.REP'                     /*the report  file.              */
monthDays.=31                          /*number of days in every month. */
monthDays.4 =30
monthDays.6 =30
monthDays.9 =30
monthDays.11=30
  otime='9999 99 99 99 99 99'          /*latest OUT time.               */
  itime='0000 00 00 00 00 00'          /*latest  IN time.               */
 lowjob=99999
highjob=0

  do while lines(ifid)\==0             /*read until finished.           */
  rec=linein(ifid)                     /*read the next record (line).   */
  parse upper var rec . InOut . datestamp . . job#      /*get some stuff*/
  $datestamp=translate(datestamp,,'/:_')
  if InOut=='IN' then do
                      in.job#=$datestamp   /*<─────assign an  IN record.*/
                      if $datestamp>Itime then itime=$datestamp
                      end
                 else do
                      out.job#=$datestamp  /*<─────assign an OUT record.*/
                      if $datestamp<otime then otime=$datestamp
                      end
   lowjob=min( lowjob,job#)
  highjob=max(highjob,job#)
  end   /*DO WHILE*/

has=0
maxhas=0
qtime=otime
mtimeL=''

  do jjj=1 until qtime>itime
  has=inRange(qtime)
  if has==maxhas then mtimeL=qtime
  if has>maxhas then do
                     maxhas=has
                     mtime=qtime
                     mtimes=qtime
                     end
  qtime=addAsec(qtime)
  end   /*DO UNTIL*/

call sy
parse var mtimes yy mm dd hh mn ss; _=yy'/'mm"/"dd hh':'mn":"ss
call sy 'maximum number of licenses out is ' maxhas " at " _

if mtimeL\=='' & mtimeL\==mtimes then
  do
  maxhas__=left('',length(maxhas)+5)
  parse var mtimeL yy mm dd hh mn ss; _=yy'/'mm"/"dd hh':'mn":"ss
  call sy '                          through ' maxhas__ _
  end

exit

/*─────────────────────────────────────addAsec subroutine───────────────*/
addAsec: procedure expose monthDays.; parse arg yy mm dd hh mn ss
ss=right(ss+1 ,2,0)                    ; if ss<60 then return yy mm dd hh mn ss
ss=right(ss-60,2,0); mn=right(mn+1,2,0); if mn<60 then return yy mm dd hh mn ss
mn=right(mn-60,2,0); hh=right(hh+1,2,0); if hh<24 then return yy mm dd hh mn ss
monthDays.2=28+leapyear(yy)
??=monthDays.mm
hh=right(hh-24,2,0); dd=right(dd+1,2,0); if dd<?? then return yy mm dd hh mn ss
mm=right(mm-??,2,0); yy=right(yy+y,4,0)
return yy mm dd hh mn ss

/*─────────────────────────────────────inRange subroutine───────────────*/
inRange: hases=0; parse arg xtime      /*see if xtime is in jobs' range.*/
  do j=lowjob to highjob
  if xtime << out.j then leave
  if xtime >>  in.j then iterate
  hases=hases+1
  end
return hases

/*─────────────────────────────────────LEAPYEAR subroutine──────────────*/
leapyear: procedure; arg y             /*year could be: Y, YY, YYY, YYYY*/
if length(y)==2 then y=left(right(date(),4),2)y    /*adjust for YY year.*/
if y//4\==0 then return 0              /* not ≈ by 4?    Not a leapyear.*/
return y//100\==0 | y//400==0          /*apply 100 and 400 year rule.   */

/*─────────────────────────────────────SY subroutine────────────────────*/
sy: procedure expose ofid; say arg(1);  call lineout ofid,arg(1);  return
