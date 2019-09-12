/*REXX program can re-define most keys (including  F  keys)  on a PC keyboard.*/
trace off
parse arg !
if !all(arg())  then exit
if !cms  then address ''

signal on halt
signal on noValue
signal on syntax

                                                   /*if not DOS, issue error. */
if \!dos     then call er 23,', DOS[environment]'

                                                   /*if not PC/REXX, issue err*/
if \!pcrexx  then call er 23,', PC/REXX[interpreter]'

                                                   /*if Windows/NT, issue err.*/
if !nt       then call er 23,!fn 'Windows/95/98/2000 REXX-program'

      /* This program requires  ANSI.SYS  if any keys are set or (re─)defined.*/
      /* ANSI.SYS won't function correctly under Windows/NT (XP, Vista, 7, 8).*/

call homeDrive                                     /*get the homeDrive envVar.*/

$home=p(!var('$HOME') homeDrive)                   /*get homeDrive of \$\ dir.*/
$home=appenda($home,':')                           /*make the drive ──► drive:*/
$path=p(!var('$PATH') '\$')                        /*get path name of \$  dir.*/
$path=prefixa($PATH,'\')                           /*make the path  ──► \dir  */
$path=appenda($path,'\')                           /*make the path  ──► dir\  */

if \hasCol($path)  then $path=$home || $path       /*prefix with  $HOME  ?    */

@DOSKEY    = 'DOSKEY'                              /*point to the DOSKEY   cmd*/
@ECHO      = 'ECHO'                                /*point to the ECHO     cmd*/
@TYPE      = 'TYPE'                                /*point to the TYPE     cmd*/
defFid     = #path'LOGS\'!fn".LOG"
oldFid     = #path'LOGS\'!fn".OLD"
tops       = '.BOX= .C=blue .H=darkcyan .E=1'
fops       = '.EF='defFid
functionKey= 0
autoEnter  =
useAuto    = 0
@offon     = 'OFF ON ,'
@warns     = 'WARNIFOFF WARNIFON ,'
sepLine    = copies('═',5)  copies('═',73)
y          = space(!!)

  do  forever                                      /*process any & all options*/
  parse var y k1 2 1 k y
  uk=k; upper uk

  if uk=='[ENTER]'    then do
                           useAuto=1
                           autoEnter=13
                           iterate
                           end

  if uk=='[NOENTER]'  then do
                           useAuto=1
                           autoEnter=
                           iterate
                           end

  if k1\=='.'         then leave
  tops=tops k
  fops=fops k
  end   /*forever*/

tops=space(tops)
fops=space(fops)
origk=space(k)
upper k

if k=='??'  |,
   k=="???" |,
   k=="????"  then do
                   !cls
                   if y==''      then y=defFid
                   @type y
                   say sepLine
                   if k=="???"   then call $defkey "ALLLOCKS , WARNIFON"

                   if k=="????"  then do
                                      call $t ".P=1 .C=blue" centre('DOSKEY macros',79,"─")
                                      @doskey '/macro'
                                      call $t ".C=blue" copies('─',79)
                                      end
                   exit rc
                   end

if k=='CLEARLOG' then do
                      lFID=defFid

                      if lFID==defFid  then do
                                            call dosdel oldFid
                                            call dosrename defFid,oldFid
                                            end
                                       else call dosdel lFID

                      call whenstamp lFID,'log file was cleared by' !fn"."
                      _='ECHO' sepLine">>"lFID
                      _
                      'ECHO  key         new value>>'lFID
                      _
                      exit
                      end

shiftkeys='NUMLOCK CAPSLOCK SCROLLLOCK ALLLOCKS'

if abbrev('BLINKLOCKKEYS',k,5)  then
     do
     parse var o . k times secs _
     if _\==''                            then call er 59
     if k=='' | k==","                    then k="ALLLOCKS"
     if wordpos(k,shiftkeys)==0           then call er 50,'shiftlock-key' origk
     if times=='' | times==','            then times="ANYKEY"
     if times\=='ANYKEY' & \isint(times)  then call er 53,times 'times'
     if secs=='' | secs==','              then secs=.1
     if \isNum(secs)                      then call er 53,times "seconds-delay-time"
     secs=secs/1
     if secs<.1 | secs>99                 then call er 81,.1 99 secs 'seconds-delay-time'
     dids=0

       do forever

         do j=1  for 3

           do jo=2  to 1  by -1
           dakey=word(shiftkeys,j)
           if k=='ALLLOCKS' | k==dakey then call "$DEFKEY" dakey word(@offon,jo)
           if secs\==0                 then call delay secs
           end   /*jo*/

         end     /*j*/

       dids=dids+1
       if times\=='ANYKEY' & dids>=times  then exit
                                          else if inkey("NOWAIT")\=='' then exit
       end   /*forever*/
     end

if wordpos(k,shiftkeys)\==0  then
     do
     _=words(y)
     if _>2  then call er 59
     onoff=
     warnif=0
     iswas='is'
     if y==','  then y=

     if y\==''  then do

                     if _==2 then do
                                  _=word(y,2)
                                  warnif=wordpos(translate(_),@warns)
                                  if warnif==0 then call er 55,_ k 'WARN'
                                  if warnif==3 then warnif=0
                                  y=subword(y,1,1)
                                  end

                     onoff=wordpos(translate(y),@offon)
                     if onoff==0 then call er 50,'ON-or-OFF' y
                     if onoff\==3 then iswas='was'
                     end

     if y==','  then y=

       do j=1  for 3
       dakey=word(shiftkeys,j)
       if warnif\==0  then if shiftstate(dakey)+1==warnif then call $t ".J=r" tops dakey iswas'('word(@offon,warnif)")"

       if k=="ALLLOCKS" | k==dakey  then
          do
          if y\=='' &,
             onoff\==3  then call shiftstate dakey,onoff-1
                        else if warnif==0 then call $t ".I=25" tops dakey 'is ('word(@offon,shiftstate(dakey)+1)")"
          end

       end   /*j*/

     exit
     end

if y==''  then call er 54
cod=
codz='Z'

if pos('-',k)\==0  then do
                        parse var k cod '-' k
                        _='S SHIFT C CTRL CONTROL A ALT ALTERNATE'
                        if cod=='' | wordpos(cod,_)==0  then call er 50,"key" origk
                        cod=left(cod,1)
                        codl=lower(cod)
                        codz=cod
                        if k==''  then call er 50,"key" origk
                        end

if abbrev('APOSTROPHE',k,5)               then k = "'"
if k=='ASTERISKKEYPAD' | k=='STARKEYPAD'  then k = "*KEYPAD"
if k=='BACKSLASH'                         then k = "\"
if k=='COMMA'                             then k = ","
if k=='DEL'                               then k = "DELETE"
if k=='DELKEYPAD'                         then k = "DELETEKEYPAD"
if k=='ENT'                               then k = "ENTER"
if k=='ENTKEYPAD'                         then k = "ENTERKEYPAD"
if k=='EQUAL'                             then k = "="
if k=='FIVEKEYPAD'                        then k = "5KEYPAD"
if k=="GRAVEACCENT" | k=='GRAVE'          then k = "`"
if k=='INSKEYPAD'                         then k = "INSKEYPAD"
if k=='LEFTBRACKET'                       then k = "["
if k=='MINUS'                             then k = "-"
if k=='MINUSKEYPAD'                       then k = "-KEYPAD"
if k=="PAUSE" | k=='BREAK'                then k = "PAUSEBREAK"
if k=='PGDN'                              then k = "PAGEDOWN"
if k=='PGDNKEYPAD'                        then k = "PAGEDOWNKEYPAD"
if k=='PGUP'                              then k = "PAGEUP"
if k=='PGUPKEYPAD'                        then k = "PAGEUPKEYPAD"
if k=='PLUSKEYPAD'                        then k = "+KEYPAD"
if k=='PRINTSCRN'                         then k = "PRINTSCREEN"
if k=='RIGHTBRACKET'                      then k = "]"
if k=='SEMICOLON'                         then k = ";"
if k=='SPACE' | k=="SPACEBAR"             then k = 'BLANK'

if wordpos(k,'PERIOD DOT DECIMAL DECIMALPOINT')\==0                       then k="."
if wordpos(k,'SLASH SOLIDUS VIRGULE OBELUS')\==0                          then k="/"
if wordpos(k,'SLASHKEYPAD SOLIDUSKEYPAD VIRGULEKEYPAD OBELUSKEYPAD')\==0  then k="/KEYPAD"
base=

  do 1                     /*the "1" enables the use of the LEAVE instruction.*/
  len1=(length(k)==1)
  uppc=isUpp(k)
  numb=isint(k)

  if len1 then do
               dkey=c2d(k)
               if uppc then do
                            if cod=='A' then do
                                             _='30 48 46 32 18 33 34 35 23 36 37 38 50 49 24 25 16 19 31 20 22 47 17 45 21 44'
                                             base='0;'word(_,dkey-96)
                                             end
                            d.z=21
                            d.s=0
                            d.c=-64
                            base=d.codz+dkey
                            end

               if numb then do
                            dakey=dkey-47
                            if cod=''   then base=dkey
                            if cod=='S' then base=word("41 33 64 35 36 37 94 38 42 49",dakey)

                            if cod=='A' then if k<3 then base="0;"word(129 120,dakey)
                                                    else base="0;"119+dakey

                            if cod=='C' then do
                                             if k==2 then base=0
                                             if k==6 then base=30
                                             end
                            end

               if base\==''  then leave
               call er 50,'key' origk
               end

  ik=wordpos(k,'DELETE DOWNARROW END HOME INSERT LEFTARROW PAGEDOWN PAGEUP RIGHTARROW UPARROW')

    select
    when left(k,1)=='F' then do
                        functionKey=1
                        fn=substr(k,2)
                        if \isint(fn) | fn<1 | fn>12  then call er 81,1 12 k "FunctionKey"
                        d.z=58
                        d.s=83
                        d.c=93
                        d.a=103
                        if fn<11  then base='0;' || (d.codz+fn)
                                  else do
                                       d.z=133-11
                                       d.s=135-11
                                       d.c=137-11
                                       d.a=139-11
                                       base='0;' || (d.codz+fn)
                                       end
                        end

    when ik\==0  then do
                      d.z='83 80 79 71 82 75 81 73 77 72'
                      d.s=d.z
                      d.c='147 145 117 119 146 115 118 132 116 141'
                      d.a='163 154 159 151 162 155 161 153 157 152'
                      base='224;'word(d.codz,ik)
                      end

    when k=='PRINTSCREEN' & cod="C"  then base='0;114'
    when k=='PAUSEBREAK'  & cod="C"  then base='0;0'
    when k=='NULL'        & cod==''  then base="0;3"

    when k=='BACKSPACE'  then do
                              d.z=8
                              d.s=8
                              d.c=127
                              d.a=0
                              base=d.codz
                              end

    when k=='TAB'   then do
                         d.z=9
                         d.s='0;15'
                         d.c='0;148'
                         d.z='0;165'
                         base=d.codz
                         end

    when k=='BLANK' then do
                         d.z=92
                         d.s=124
                         d.c=28
                         d.a='0;43'
                         base=d.codz
                         end

    when k=='ENTER' then do
                         d.z=13
                         d.s=
                         d.c=10
                         d.a='0;28'
                         base=d.codz
                         end

    when k=='-'  then do
                      d.z=45
                      d.s=95
                      d.c=31
                      d.a='0;130'
                      base=d.codz
                      end

    when k=='='  then do
                      d.z=61
                      d.s=43
                      d.c=
                      d.a='0;131'
                      base=d.codz
                      end

    when k=='['  then do
                      d.z=91
                      d.s=123
                      d.c=27
                      d.a='0;26'
                      base=d.codz
                      end

    when k==']'  then do
                      d.z=93
                      d.s=125
                      d.c=29
                      d.a='0;27'
                      base=d.codz
                      end

    when k=='\'  then do
                      d.z=92
                      d.s=124
                      d.c=28
                      d.a='0;43'
                      base=d.codz
                      end

    when k==';'  then do
                      d.z=59
                      d.s=58
                      d.c=
                      d.a='0;39'
                      base=d.codz
                      end

    when k=="'"  then do
                      d.z=39
                      d.s=34
                      d.c=
                      d.a='0;40'
                      base=d.codz
                      end

    when k==','  then do
                      d.z=44
                      d.s=60
                      d.c=
                      d.a='0;51'
                      base=d.codz
                      end

    when k=='.'  then do
                      d.z=46
                      d.s=62
                      d.c=
                      d.a='0;52'
                      base=d.codz
                      end

    when k=='/'  then do
                      d.z=47
                      d.s=63
                      d.c=
                      d.a='0;53'
                      base=d.codz
                      end

    when k=='`'  then do
                      d.z=96
                      d.s=126
                      d.c=
                      d.a='0;41'
                      base=d.codz
                      end

    when k=='HOMEKEYPAD'  then do
                               d.z='0;71'
                               d.s=55
                               d.c='0;119'
                               base=d.codz
                               end

    when k=='UPARROWKEYPAD'  then do
                                  d.z='0;72'
                                  d.s=55
                                  d.c='0;141'
                                  base=d.codz
                                  end

    when k=='PAGEUPKEYPAD'  then do
                                 d.z='0;73'
                                 d.s=57
                                 d.c='0;132'
                                 base=d.codz
                                 end

    when k=='LEFTARROWKEYPAD'  then do
                                    d.z='0;75'
                                    d.s=52
                                    d.c='0;115'
                                    base=d.codz
                                    end

    when k=='5KEYPAD'  then do
                            d.z='0;76'
                            d.s=53
                            d.c='0;143'
                            base=d.codz
                            end

    when k=='RIGHTARROWKEYPAD'  then do
                                     d.z='0;77'
                                     d.s=54
                                     d.c='0;116'
                                     base=d.codz
                                     end

    when k=='ENDKEYPAD'  then do
                              d.z='0;79'
                              d.s=49
                              d.c='0;117'
                              base=d.codz
                              end

    when k=='DOWNARROWKEYPAD'  then do
                                    d.z='0;80'
                                    d.s=50
                                    d.c='0;145'
                                    base=d.codz
                                    end

    when k=='PAGEDOWNKEYPAD'  then do
                                   d.z='0;81'
                                   d.s=51
                                   d.c='0;118'
                                   base=d.codz
                                   end

    when k=='INSERTKEYPAD'  then do
                                 d.z='0;82'
                                 d.s=48
                                 d.c='0;146'
                                 base=d.codz
                                 end

    when k=='DELETEKEYPAD'  then do
                                 d.z='0;83'
                                 d.s=46
                                 d.c='0;147'
                                 base=d.codz
                                 end

    when k=='ENTERKEYPAD'  then do
                                d.z=13
                                d.c=10
                                d.a='0;166'
                                base=d.codz
                                end

    when k=='/KEYPAD'  then do
                            d.z=47
                            d.s=d.z
                            d.c='0;142'
                            d.a='0;74'
                            base=d.codz
                            end

    when k=='*KEYPAD'  then do
                            d.z=42
                            d.s='o;144'
                            d.c='0;78'
                            base=d.codz
                            end

    when k=='-KEYPAD'  then do
                            d.z=45
                            d.s=d.z
                            d.c='0;149'
                            d.a='0;164'
                            base=d.codz
                            end

    when k=='+KEYPAD'  then do
                            d.z=43
                            d.s=d.z
                            d.c='0;150'
                            d.a='0;55'
                            base=d.codz
                            end
    otherwise  nop
    end   /*select*/

  if base\==''  then leave
  call er 50,'key' origk
  end    /*do 1*/

jy=words(y)
yy=

  do j=1  for jy
  w=word(y,j)
  lw=length(w)
  lc=left(w,1)
  rc2=right(w,2);  upper rc2

  if ((lc=='"' & rc2=='"X') | (lc=="'" & rc2=="'X")) & lw>3  then
     do
     if (lw-3)//2\==0  then call er 56,w 'hexdigits for the hexstring' w
     wm=substr(w,2,lw-3)
     if \isHex(wm)     then call er 40,w
     w=x2c(wm)
     end

  yy=yy w
  end   /*j*/
                                     /*if useAuto=1, then use AUTOENTER as is.*/
                                     /*if useAuto=0 & funcKey, then use ENTER.*/
if \useAuto & functionKey  then autoEnter=13
yy=substr(yy,2)
!!='1b'x"["                          /* ESC[s  ───►  save    cursor position. */
                                     /* ESC[u  ───►  restore cursor position. */
                                     /* ESC[1A ───►  move    cursor up 1 line.*/

@echo !!"s"!! || base';"'yy'";'autoEnter'p'!!"u"!!'1A'     /*issue the define.*/
nk=k
if cod\==''  then nk=codl"-"k

call $t '.Q=1' fops right(nk,max(length(nk),5)) "──►" yy
exit                                   /*stick a fork in it,  we're all done. */

/*═════════════════════════════one─liner subroutines══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════*/
!all:  !!=!;!=space(!);upper !;call !FID;!nt=right(!var('OS'),2)=="NT";!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,"? ?SAMPLES ?AUTHOR ?FLOW")==0 then return 0;!call=']$H';call '$H' !fn !;!call=;return 1
!cal:  if symbol('!CALL')\=="VAR"  then !call=; return !call
!env:  !env='ENVIRONMENT';  if !sys=='MSDOS' | !brexx | !r4 | !roo  then !env='SYSTEM';  if !os2  then !env='OS2'!env;  !ebcdic=1=='f0'x;   return
!FID:  parse upper source !sys !fun !FID . 1 . . !fn !ft !fm .; call !sys; if !dos  then do; _=lastpos('\',!fn); !fm=left(!fn,_); !fn=substr(!fn,_+1); parse var !fn !fn '.' !ft; end; return word(0 !fn !ft !fm,1+("0"arg(1)))
!rex:  parse upper version !ver !vernum !verdate .;  !brexx='BY'==!vernum;  !kexx='KEXX'==!ver;  !pcrexx='REXX/PERSONAL'==!ver | 'REXX/PC'==!ver;  !r4='REXX-R4'==!ver;  !regina='REXX-REGINA'==left(!ver,11);  !roo='REXX-ROO'==!ver;  call !env;  return
!sys:  !cms=!sys=='CMS';  !os2=!sys=="OS2";  !tso=!sys=='TSO' | !sys=="MVS";  !vse=!sys=='VSE';  !dos=pos("DOS",!sys)\==0 | pos('WIN',!sys)\==0 | !sys=="CMD";  call !rex;    return
!var:  call !FID;  if !kexx  then return space(dosenv(arg(1)));   return space(value(arg(1),,!env))

$defkey:   !call=']$DEFKEY';  call "$DEFKEY" arg(1);  !call=;     return result
$t:        !call=']$T';       call "$T" arg(1);       !call=;     return result
appenda:   procedure;  parse arg x,_;  if right(x,length(_))\==_  then x=x || _;            return x
er:        parse arg _1,_2;  call '$ERR' "14"p(_1) p(word(_1,2) !FID(1)) _2;  if _1<0  then return _1;    exit result
halt:      call er .1
hasCol:    return pos(':',arg(1))\==0
homeDrive: if symbol('HOMEDRIVE')\=="VAR"  then homeDrive=p(!var('HOMEDRIVE') 'C:');   return homeDrive
isHex:     return datatype(arg(1),'X')
isint:     return datatype(arg(1),'W')
isNum:     return datatype(arg(1),'N')
isUpp:     return datatype(arg(1),'U')
it:        "ARG"(1);if rc==0  then return;  call er 68,rc arg(1)
noValue:   !sigl=sigl;  call er 17,!FID(2) !FID(3) !sigl condition('D') sourceline(!sigl)
p:         return word(arg(1),1)
prefixa:   procedure;  parse arg x,_;  if left(x,length(_))\==_  then x=_ || x;   return x
squish:    return space(translate(arg(1),,word(arg(2) ',',1)),0)
syntax:    !sigl=sigl;  call er 13,!FID(2) !FID(3) !sigl !cal() condition('D') sourceline(!sigl)
whenstamp: arg whenFID;  call lineout whenFID,strip(left(date('U'),6)left(date("S"),4) time() arg(2));  call lineout whenFID,' ';  call lineout whenFID;   return
