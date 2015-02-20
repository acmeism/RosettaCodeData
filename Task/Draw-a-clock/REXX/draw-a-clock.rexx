/**/trace o;parse arg !;if !all(arg()) then exit;if !cms then address ''
signal on halt; signal on novalue; signal on syntax
parse var ! ops;   ops = space(ops)    /*obtain  command line  options. */
@abc = 'abcdefghijklmnopqrstuvwxyz'    /*alphabet str used by ABB/ABBN. */
blinkSecs = 1
creep     = 1
tops      = '.C=blue .BC=░ .BS=1 .BLOCK=12'

  do while ops\=='';    parse var ops _1 2 1 _ . 1 y ops;    upper _
    select
    when _==','                    then nop
    when _1=='.' & pos("=",_)\==0  then tops=tops y
    when abbn('BLINKSECs')         then blinksecs=no()
    when abbn('CREEPs')            then creep=no()
    otherwise                      call er 55,y
    end   /*select*/
  end     /*while ops¬==''*/

if \!pcrexx  then  blinkSecs=0         /*if ¬PC/REXX, turn off BLINKSECS*/
tops=space(tops)                       /*elide extraneous  TOPS  blanks.*/
parse value  scrsize()  with  sd sw .  /*get the term screens dimensions*/
oldTime=
           do until queued()\==0
           ct=time();  mn=substr(ct,4,2);  ss=right(ct,2);   i_=0;   p_=0
           call blinksec
           if ct==oldTime  then if !cms then 'CP SLEEP'; else call delay 1

           if creep  then do;            p_ =  3 + right(mn,1)
                          if sd>26  then p_ = p_ + left(mn,1)
                          if sd>33  then p_ = p_ + left(mn,1)
                          if sd>44  then p_ = p_ + left(mn,1) +right(mn,1)
                          end
           _p=-p_
           i_=2+left(ct,1);     ctt=left(ct,5);    if sw>108  then ctt=ct
           r=$t('.P='_p ".I="i_ tops ctt);         if r\==0   then leave
           oldTime=time()
           end   /*forever*/
exit                                   /*stick a fork in it, we're done.*/
/*═════════════════════════════general 1-line subs════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════*/
!all:!!=!;!=space(!);upper !;call !fid;!nt=right(!var('OS'),2)=='NT';!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,'? ?SAMPLES ?AUTHOR ?FLOW')==0 then return 0;!call=']$H';call '$H' !fn !;!call=;return 1
!cal: if symbol('!CALL')\=="VAR" then !call=;return !call
!env: !env='ENVIRONMENT';if !sys=='MSDOS'|!brexx|!r4|!roo then !env='SYSTEM';if !os2 then !env='OS2'!env;!ebcdic=1=='f0'x;return
!fid: parse upper source !sys !fun !fid . 1 . . !fn !ft !fm .;call !sys;if !dos then do;_=lastpos('\',!fn);!fm=left(!fn,_);!fn=substr(!fn,_+1);parse var !fn !fn '.' !ft;end;return word(0 !fn !ft !fm,1+('0'arg(1)))
!rex: parse upper version !ver !vernum !verdate .;!brexx='BY'==!vernum;!kexx='KEXX'==!ver;!pcrexx='REXX/PERSONAL'==!ver|'REXX/PC'==!ver;!r4='REXX-R4'==!ver;!regina='REXX-REGINA'==left(!ver,11);!roo='REXX-ROO'==!ver;call !env;return
!sys: !cms=!sys=='CMS';!os2=!sys=='OS2';!tso=!sys=='TSO'|!sys=='MVS';!vse=!sys=='VSE';!dos=pos('DOS',!sys)\==0|pos('WIN',!sys)\==0|!sys=='CMD';call !rex;return
!var: call !fid;if !kexx then return space(dosenv(arg(1)));return space(value(arg(1),,!env))
$t:   !call=']$T';call "$T" arg(1);!call=;return result
abb:  arg abbu;parse arg abb;return abbrev(abbu,_,abbl(abb))
abbl: return verify(arg(1)'a',@abc,'M')-1
abbn: parse arg abbn;return abb(abbn)|abb('NO'abbn)
blinksec: if \blinksecs then return;bsec=' ';ss2=right(ss,2);if sw<=80 then bsec=copies(' ',2+ss2) ss2;call scrwrite 1+right(mn,1),1,bsec,,,1;call cursor sd-right(mn,1),sw-length(bsec);return
er:   parse arg _1,_2;call '$ERR' "14"p(_1) p(word(_1,2) !fid(1)) _2;if _1<0 then return _1;exit result
err:  call er '-'arg(1),arg(2);return ''
erx:  call er '-'arg(1),arg(2);exit ''
halt: call er .1
no:   if arg(1)\=='' then call er 01,arg(2);return left(_,2)\=='NO'
novalue:!sigl=sigl;call er 17,!fid(2) !fid(3) !sigl condition('D') sourceline(!sigl)
p:    return word(arg(1),1)
syntax:!sigl=sigl;call er 13,!fid(2) !fid(3) !sigl !cal() condition('D') sourceline(!sigl)
