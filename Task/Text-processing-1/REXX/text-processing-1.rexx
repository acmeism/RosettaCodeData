/*REXX program to process  instrument data  from a  data file.          */
numeric digits 20                      /*allow for bigger numbers.      */
ifid='READINGS.TXT'                    /*the  input  file.              */
ofid='READINGS.OUT'                    /*the  outut  file.              */
grandSum=0                             /*grand sum of whole file.       */
grandflg=0                             /*grand num of flagged data.     */
grandOKs=0
longFlag=0                             /*longest period of flagged data.*/
contFlag=0                             /*longest continous flagged data.*/
w=16                                   /*width of fields when displayed.*/

  do recs=1  while lines(ifid)\==0     /*read until finished.           */
  rec=linein(ifid)                     /*read the next record (line).   */
  parse var rec datestamp Idata        /*pick off the dateStamp & data. */
  sum=0
  flg=0
  OKs=0

    do j=1  until Idata=''             /*process the instrument data.  */
    parse var Idata data.j flag.j Idata

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

  if OKs\==0 then avg=format(sum/OKs,,3)
             else avg='[n/a]'
  grandOKs=grandOKs+OKs
  _=right(comma(avg),w)
  grandSum=grandSum+sum
  grandFlg=grandFlg+flg
  if flg==0 then call sy datestamp ' average='_
            else call sy datestamp ' average='_ '  flagged='right(flg,2)
  end   /*recs*/

recs=recs-1                            /*adjust for reading end-of-file.*/
if grandOKs\==0 then Gavg=format(grandsum/grandOKs,,3)
                else Gavg='[n/a]'
call sy
call sy copies('═',60)
call sy '      records read:' right(comma(recs),w)
call sy '     grand     sum:' right(comma(grandSum),w+4)
call sy '     grand average:' right(comma(Gavg),w+4)
call sy '     grand OK data:' right(comma(grandOKs),w)
call sy '     grand flagged:' right(comma(grandFlg),w)
if longFlag\==0 then
call sy '   longest flagged:' right(comma(longFlag),w) " ending at " longdate
call sy copies('═',60)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SY subroutine───────────────────────*/
sy: procedure; parse arg stuff;   say stuff
    if  1==0  then  call lineout ofid,stuff
    return
/*──────────────────────────────────COMMA subroutine────────────────────*/
comma: procedure; parse arg _,c,p,t;arg ,cu;c=word(c ",",1)
       if cu=='BLANK' then c=' ';o=word(p 3,1);p=abs(o);t=word(t 999999999,1)
       if \datatype(p,'W')|\datatype(t,'W')|p==0|arg()>4 then return _;n=_'.9'
       #=123456789;k=0;if o<0 then do;b=verify(_,' ');if b==0 then return _
       e=length(_)-verify(reverse(_),' ')+1;end;else do;b=verify(n,#,"M")
       e=verify(n,#'0',,verify(n,#"0.",'M'))-p-1;end
       do j=e to b by -p while k<t;_=insert(c,_,j);k=k+1;end;return _
