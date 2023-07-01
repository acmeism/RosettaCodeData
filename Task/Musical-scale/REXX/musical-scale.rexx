/*REXX program  sounds  eight notes  of the    C  major   natural diatonic  music scale.*/
parse arg !                                      /*obtain optional arguments from the CL*/
                                                 /* [↓]  invoke boilerplate REXX code.  */
if !all( arg() )  then exit                      /*determine which REXX is running,  if */
                                                 /*    any form of help requested, exit.*/
if \!regina   & \!pcrexx  then do
                               say "***error***  this program can't execute under:"   !ver
                               exit 13
                               end

$ = 'do ra me fa so la te do'                    /*the words for music scale sounding.  */
dur = 1/4                                        /*define duration as a quarter second. */
           do j=1  for words($)                  /*sound each "note" in the string.     */
           call notes word($, j), dur            /*invoke a subroutine for the sounds.  */
           end   /*j*/                           /* [↑]   sound each of the words.      */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
notes: procedure expose !regina !pcrexx; arg note,dur /*obtain the arguments from list. */
       @.= 0                                          /*define common names for sounds. */
       @.la= 220;        @.si= 246.94;    @.te= @.si;      @.ta= @.te;    @.ti=  @.te
       @.do= 261.6256;   @.ut= @.do;      @.re= 293.66;    @.ra= @.re;    @.mi=  329.63
       @.ma= @.mi;       @.fa= 349.23;    @.so= 392;                      @.sol= @.so
       if @.note==0  then return                      /*if frequency is zero,  skip it. */
       if !pcrexx  then call  sound @.note,dur        /*sound the note using SOUND bif. */
       if !regina  then do                            /* [↓]  reformat some numbers.    */
                        ms= format(dur*1000, , 0)     /*Regina requires DUR in millisec.*/
                        intN= format(@.note, , 0)     /*   "      "     NOTE is integer.*/
                        call  beep  intN, ms          /*sound the note using  BEEP  BIF.*/
                        end
       return
/*─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
!all: !!=!;!=space(!);upper !;call !fid;!nt=right(!var('OS'),2)=='NT';!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,'? ?SAMPLES ?AUTHOR ?FLOW')==0 then return 0;!call=']$H';call '$H' !fn !;!call=;return 1
!cal: if symbol('!CALL')\=="VAR"  then !call=;                             return !call
!env: !env= 'ENVIRONMENT';   if !sys=="MSDOS"  |  !brexx  |  !r4  |  !roo  then !env= 'SYSTEM';   if !os2  then !env= "OS2"!env;   !ebcdic= 3=='f3'x;   if !crx  then !env="DOS";                    return
!fid: parse upper source !sys !fun !fid . 1 . . !fn !ft !fm .;  call !sys;  if !dos  then do;  _= lastpos('\',!fn);  !fm= left(!fn,_);  !fn= substr(!fn,_+1);  parse var !fn !fn "." !ft;  end;      return word(0 !fn !ft !fm, 1 + ('0'arg(1) ) )
!rex: parse upper version !ver !vernum !verdate .;  !brexx= 'BY'==!vernum; !kexx= "KEXX"==!ver; !pcrexx= 'REXX/PERSONAL'==!ver | "REXX/PC"==!ver; !r4= 'REXX-R4'==!ver; !regina= "REXX-REGINA"==left(!ver, 11); !roo= 'REXX-ROO'==!ver; call !env; return
!sys: !cms= !sys=='CMS';   !os2= !sys=="OS2";   !tso= !sys=='TSO'  |  !sys=="MVS";   !vse= !sys=='VSE';   !dos= pos("DOS", !sys)\==0  |  pos('WIN', !sys)\==0  |  !sys=="CMD";   !crx= left(!sys, 6)=='DOSCRX';                         call !rex; return
!var: call !fid;   if !kexx  then return space( dosenv( arg(1) ) );        return space( value( arg(1), , !env) )
