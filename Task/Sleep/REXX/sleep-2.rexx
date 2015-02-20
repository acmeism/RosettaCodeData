/*REXX program  delays  (or SLEEPS)  a number of  whole  seconds.       */
trace off                                    /*suppress REXX error msgs.*/
parse arg !                                  /*obtain all the arguments.*/
if !all(arg()) then exit                     /*documentation requested? */
if !cms  then address ''                     /*if CMS, use fast cmd path*/
signal on halt                               /*handle  HALT  gracefully.*/
signal on noValue                            /*handle REXX noValue error*/
signal on syntax                             /*handle REXX syntax errors*/

/*┌────────────────────────────────────────────────────────────────────┐
┌─┘ The  DELAY  function is used to delay (wait) a specific amount of  └─┐
│ (wall-clock)  time specified in seconds.  Any fraction part is ignored.│
│                                                                        │
│ If the REXX program invoking  DELAY  function is running under PC/REXX │
│ or  Personal REXX,  this REXX program should never be invoked as those │
└─┐ REXXes have their own built-in function (BIF)  named   "DELAY".    ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/

@cpsleep  = 'CP SLEEP'                       /*point to (CP) SLEEP   cmd*/
@ping     = 'PING'                           /*point to the DOS PING cmd*/

parse var ! n _                              /*parse argument from parms*/
if _\=='' | arg()>1  then call er 59         /*are there too many args? */
if n==''             then n=1                /*no arg? Then assume 1 sec*/
if \isNum(n)  then call er 53,n 'delay-seconds'     /*is   n   numeric? */
n=n%1                                        /*elide any fractional part*/
if n<=0  then return 0
                        /* ┌────────────────────┐ */
                        /* │ delay  n  seconds. │ */
                        /* └────────────────────┘ */
  select
  when !cms     then @cpsleep n%1 "SEC"              /*CMS? Use CP SLEEP*/
  when !tso     then call sleep n%1                  /*TSO?    Use SLEEP*/
  when !regina  then call sleep n%1                  /*Regina? Use SLEEP*/
  when !dos     then @ping '-n' n "127.0.0.1 > NUL"  /*DOS?    use PING */
  otherwise          nop
  end   /*select*/

return 0                                     /*return a zero value.     */

/*═════════════════════════════general 1-line subroutines═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════*/
!all:  !!=!;!=space(!);upper !;call !fid;!nt=right(!var('OS'),2)=='NT';!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,'? ?SAMPLES ?AUTHOR ?FLOW')==0 then return 0;!call=']$H';call '$H' !fn !;!call=;return 1
!cal:    if symbol('!CALL')\=="VAR"  then !call=;     return !call
!env:    !env='ENVIRONMENT'; if !sys=='MSDOS' | !brexx | !r4 | !roo  then !env='SYSTEM'; if !os2  then !env='OS2'!env; !ebcdic=1=='f0'x; if !crx  then !env='DOS';  return
!fid:    parse upper source !sys !fun !fid . 1 . . !fn !ft !fm .; call !sys; if !dos  then do; _=lastpos('\',!fn); !fm=left(!fn,_); !fn=substr(!fn,_+1); parse var !fn !fn '.' !ft; end;   return word(0 !fn !ft !fm, 1+('0'arg(1)))
!rex:    parse upper version !ver !vernum !verdate .; !brexx='BY'==!vernum; !kexx='KEXX'==!ver; !pcrexx='REXX/PERSONAL'==!ver | 'REXX/PC'==!ver; !r4='REXX-R4'==!ver; !regina='REXX-REGINA'==left(!ver,11); !roo='REXX-ROO'==!ver; call !env; return
!sys:    !cms=!sys=='CMS'; !os2=!sys=='OS2'; !tso=!sys=='TSO' | !sys=='MVS'; !vse=!sys=='VSE'; !dos=pos('DOS',!sys)\==0 | pos('WIN',!sys)\==0 | !sys=='CMD'; !crx=left(!sys,6)=='DOSCRX'; call !rex; return
!var:    call !fid; if !kexx  then return space(dosenv(arg(1))); return space(value(arg(1),,!env))
er:      parse arg _1,_2; call '$ERR' "14"p(_1) p(word(_1,2) !fid(1)) _2; if _1<0  then return _1;     exit result
p:       return word(arg(1),1)
halt:    call er .1
isNum:   return datatype(arg(1),'N')
noValue: !sigl=sigl; call er 17,!fid(2) !fid(3) !sigl condition('D') sourceline(!sigl)
syntax:  !sigl=sigl; call er 13,!fid(2) !fid(3) !sigl !cal() condition('D') sourceline(!sigl)
