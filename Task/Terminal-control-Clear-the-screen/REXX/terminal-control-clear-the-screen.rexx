/*REXX boilerplate determines how to clear screen (under various REXXes)*/
trace off;      parse arg !            /*turn off tracing; get C.L. args*/
if !all(arg())  then exit              /*Doc request?   Show, then exit.*/
if !cms then address ''                /*Is this CMS?  Use this address.*/

!cls                                   /*clear the (terminal) screen.   */            /* ◄═══   this is where  "it"  happens.*/

exit                                   /*stick a fork in it, we're done.*/
/*═════════════════════════════general 1-line subs══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════*/
!all:  !!=!;!=space(!);upper !;call !fid;!nt=right(!var('OS'),2)=='NT';!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,'? ?SAMPLES ?AUTHOR ?FLOW')==0 then return 0;!call=']$H';call '$H' !fn !;!call=;return 1
!cal:  if symbol('!CALL')\=="VAR" then !call=; return !call
!env:  !env='ENVIRONMENT'; if !sys=='MSDOS'|!brexx|!r4|!roo then !env='SYSTEM'; if !os2 then !env='OS2'!env; !ebcdic=1=='f0'x; if !crx then !env='DOS'; return
!fid:  parse upper source !sys !fun !fid . 1 . . !fn !ft !fm .; call !sys; if !dos then do; _=lastpos('\',!fn); !fm=left(!fn,_); !fn=substr(!fn,_+1); parse var !fn !fn '.' !ft; end; return word(0 !fn !ft !fm,1+('0'arg(1)))
!rex:  parse upper version !ver !vernum !verdate .; !brexx='BY'==!vernum; !kexx='KEXX'==!ver; !pcrexx='REXX/PERSONAL'==!ver|'REXX/PC'==!ver; !r4='REXX-R4'==!ver; !regina='REXX-REGINA'==left(!ver,11); !roo='REXX-ROO'==!ver; call !env; return
!sys:  !cms=!sys=='CMS'; !os2=!sys=='OS2'; !tso=!sys=='TSO'|!sys=='MVS'; !vse=!sys=='VSE'; !dos=pos('DOS',!sys)\==0|pos('WIN',!sys)\==0|!sys=='CMD'; !crx=left(!sys,6)=='DOSCRX'; call !rex; return
!var:  call !fid; if !kexx then return space(dosenv(arg(1))); return space(value(arg(1),,!env))
