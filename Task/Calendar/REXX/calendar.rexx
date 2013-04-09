/*REXX program to show any year's (monthly) calendar (with/without grid)*/

@abc='abcdefghijklmnopqrstuvwxyz'; @abcU=@abc; upper @abcU
calfill=' '; mc=12; _='1 3 1234567890' "fb"x
parse var _ grid calspaces # chk . cv_ days.1 days.2 days.3 daysn sd sw
_=0; parse var _ cols 1 jd 1 lowerCase 1 maxKalPuts 1 narrow 1,
                 narrower 1 narrowest 1 short 1 shorter 1 shortest 1,
                 small 1 smaller 1 smallest 1 upperCase
parse arg mm '/' dd "/" yyyy _ '(' ops;  uops=ops
if _\=='' | \is#(mm) | \is#(dd) | \is#(yyyy) then call erx 86

  do while ops\==''; ops=strip(ops,'L'); parse var ops _1 2 1 _ . 1 _o ops
  upper _
       select
       when  abb('CALSPaces')  then calspaces=nai()
       when  abb('DEPth')      then        sd=nai()
       when abbn('GRIDs')      then      grid=no()
       when abbn('LOWercase')  then lowerCase=no()
       when  abb('CALMONths')  then        mc=nai()
       when abbn('NARrow')     then    narrow=no()
       when abbn('NARROWER')   then  narrower=no()
       when abbn('NARROWESt')  then narrowest=no()
       when abbn('SHORt')      then     short=no()
       when abbn('SHORTER')    then   shorter=no()
       when abbn('SHORTESt')   then  shortest=no()
       when abbn('SMALl')      then     small=no()
       when abbn('SMALLER')    then   smaller=no()
       when abbn('SMALLESt')   then  smallest=no()
       when abbn('UPPercase')  then upperCase=no()
       when  abb('WIDth')      then        sw=nai()
       otherwise nop
       end    /*select*/
  end         /*do while opts\== ...*/

mc=int(mc,'monthscalender'); if mc>0 then cal=1
days='Sunday Monday Tuesday Wednesday Thursday Friday Saturday'
months='January February March April May June July August September October November December'
days=' 'days;  months=' 'months
cyyyy=right(date(),4);  hyy=left(cyyyy,2);  lyy=right(cyyyy,2)
dy.=31; _=30; parse var _ dy.4 1 dy.6 1 dy.9 1 dy.11; dy.2=28+ly(yyyy)
yy=right(yyyy,2); sd=p(sd 43); sw=p(sw 80); cw=10; cindent=1; calwidth=76
if small    then do; narrow=1   ; short=1   ; end
if smaller  then do; narrower=1 ; shorter=1 ; end
if smallest then do; narrowest=1; shortest=1; end
if shortest then shorter=1
if shorter  then short  =1
if narrow    then do; cw=9; cindent=3; calwidth=69; end
if narrower  then do; cw=4; cindent=1; calwidth=34; end
if narrowest then do; cw=2; cindent=1; calwidth=20; end
cv_=calwidth+calspaces+2
calfill=left(copies(calfill,cw),cw)
      do j=1 for 7;         _=word(days,j)
            do jw=1 for 3;  _d=strip(substr(_,cw*jw-cw+1,cw))
            if jw=1 then _d=centre(_d,cw+1)
                    else _d=left(_d,cw+1)
            days.jw=days.jw||_d
            end   /*jw*/
      __=daysn
      if narrower  then daysn=__||centre(left(_,3),5)
      if narrowest then daysn=__||center(left(_,2),3)
      end   /*j*/
_yyyy=yyyy; calPuts=0; cv=1; _mm=mm+0; month=word(months,mm)
dy.2=28+ly(_yyyy); dim=dy._mm; _dd=01; dow=dow(_mm,_dd,_yyyy); $dd=dd+0

/*ââââââââââââââââââââââââââââânow: the business of the building the cal*/
call calGen
               do _j=2 to mc
               if cv_\=='' then do
                                cv=cv+cv_
                                if cv+cv_>=sw then do; cv=1; call calPut
                                                   call fcalPuts;call calPb
                                                   end
                                              else calPuts=0
                                end
                           else do;call calPb;call calPut;call fcalPuts;end
               _mm=_mm+1;  if _mm==13 then do;  _mm=1; _yyyy=_yyyy+1;  end
               month=word(months,_mm); dy.2=28+ly(_yyyy); dim=dy._mm
               dow=dow(_mm,_dd,_yyyy); $dd=0; call calGen
               end   /*_j*/
call fcalPuts
return _

/*âââââââââââââââââââââââââââââcalGen subroutineââââââââââââââââââââââââ*/
calGen: cellX=;cellJ=;cellM=;calCells=0;calline=0
call calPut
call calPutl copies('â',calwidth),"ââ"; call calHd
call calPutl month ' ' _yyyy          ; call calHd
if narrowest | narrower then call calPutl daysn
                        else do jw=1 for 3
                             if space(days.jw)\=='' then call calPutl days.jw
                             end
calft=1; calfb=0
  do jf=1 for dow-1; call cellDraw calFill,calFill; end
  do jy=1 for dim; call cellDraw jy; end
calfb=1
  do 7; call cellDraw calFill,calFill; end
if sd>32 & \shorter then call calPut
return

/*âââââââââââââââââââââââââââââcellDraw subroutineââââââââââââââââââââââ*/
cellDraw: parse arg zz,cdDOY;zz=right(zz,2);calCells=calCells+1
if calCells>7 then do
                   calLine=calLine+1
                   cellX=substr(cellX,2)
                   cellJ=substr(cellJ,2)
                   cellM=substr(cellM,2)
                   cellB=translate(cellX,,")(â-"#)
                   if calLine==1 then call cx
                   call calCsm; call calPutl cellX; call calCsj; call cx
                   cellX=; cellJ=; cellM=; calCells=1
                   end
cdDOY=right(cdDOY,cw); cellM=cellM'â'center('',cw)
cellX=cellX'â'centre(zz,cw); cellJ=cellJ'â'center('',cw)
return

/*âââââââââââââââââââââââââââââgeneral 1-line subsââââââââââââââââââââââ*/
abb: arg abbu; parse arg abb; return abbrev(abbu,_,abbl(abb))
abbl: return verify(arg(1)'a',@abc,'M')-1
abbn: parse arg abbn; return abb(abbn) | abb('NO'abbn)
calCsj: if sd>49 & \shorter then call calPutl cellB; if sd>24 & \short    then call calPutl cellJ; return
calCsm: if sd>24 & \short   then call calPutl cellM; if sd>49 & \shorter  then call calPutl cellB; return
calHd:  if sd>24 & \shorter then call calPutl      ; if sd>32 & \shortest then call calPutl      ; return
calPb:  calPuts=calPuts+1; maxKalPuts=max(maxKalPuts,calPuts); if symbol('CT.'calPuts)\=='VAR' then ct.calPuts=; ct.calPuts=overlay(arg(1),ct.calPuts,cv); return
calPutl: call calPut copies(' ',cindent)left(arg(2)"â",1)center(arg(1),calwidth)||right('â'arg(2),1);return
cx:cx_='ââ¤';cx=copies(copies('â',cw)'â¼',7);if calft then do;cx=translate(cx,'â¬',"â¼");calft=0;end;if calfb then do;cx=translate(cx,'â´',"â¼");cx_='ââ';calfb=0;end;call calPutl cx,cx_;return
dow: procedure; arg m,d,y; if m<3 then do; m=m+12; y=y-1; end; yl=left(y,2); yr=right(y,2); w=(d+(m+1)*26%10+yr+yr%4+yl%4+5*yl)//7; if w==0 then w=7; return w
er :parse arg _1,_2; call '$ERR' "14"p(_1) p(word(_1,2) !fid(1)) _2;if _1<0 then return _1; exit result
err: call er '-'arg(1),arg(2); return ''
erx: call er '-'arg(1),arg(2); exit ''
fcalPuts: do j=1 for maxKalPuts; call put ct.j; end; ct.=; maxKalPuts=0; calPuts=0; return
int: int=numx(arg(1),arg(2));if \isint(int) then call erx 92,arg(1) arg(2); return int/1
is#: return verify(arg(1),#)==0
isint: return datatype(arg(1),'W')
lower:return translate(arg(1),@abc,@abcU)
ly: if arg(1)\=='' then call erx 01,arg(2);parse var ops na ops;if na=='' then call erx 35,_o;return na
nai: return int(na(),_o)
nan: return numx(na(),_o)
no: if arg(1)\=='' then call erx 01,arg(2); return left(_,2)\=='NO'
num: procedure;parse arg x .,f,q;if x=='' then return x;if datatype(x,'N') then return x/1;x=space(translate(x,,','),0);if datatype(x,'N') then return x/1;return numnot()
numnot: if q==1 then return x;if q=='' then call er 53,x f;call erx 53,x f
numx: return num(arg(1),arg(2),1)
p: return word(arg(1),1)
put: _=arg(1);_=translate(_,,'_'chk);if \grid then _=ungrid(_);if lowerCase then _=lower(_);if upperCase then upper _;if shortest&_=' ' then return;call tell _;return
tell: say arg(1);return
ungrid: return translate(arg(1),,"âââââ¤âââ´â¬ââ¼ââââââââ¢ââ¡â«âªâ¤â§â¥â¨â â£")
