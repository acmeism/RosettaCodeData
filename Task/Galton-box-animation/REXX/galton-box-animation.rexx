/*REXX pgm simulates Sir Francis Galton's box, aka: Galton Board, quincunx, bean machine*/
if !all(arg())  then exit                        /*Any documentation was wanted?   Done.*/
if !cms         then address ''                  /*handle ADDRESS for CMS oper. system. */
trace off                                        /*suppress error messages from a HALT. */
signal on halt                                   /*allow the user to  halt  the program.*/
parse arg rows balls freeze seed .               /*obtain optional arguments from the CL*/
if rows ==''  |  rows==","   then   rows=   0    /*Not specified?  Then use the default.*/
if balls==''  | balls==","   then  balls= 100    /* "      "         "   "   "     "    */
if freeze=='' | freeze==","  then freeze=   0    /* "      "         "   "   "     "    */
if datatype(seed, 'W')   then call random ,,seed /*Was a seed specified?  Then use seed.*/
parse value  scrsize()  with  sd  sw  .          /*obtain the terminal depth and width. */
if sd==0  then sd= 40                            /*Not defined by the OS?  Use a default*/
if sw==0  then sw= 80                            /* "     "     "  "   "    "  "    "   */
sd= sd - 3                                       /*define the usable       screen depth.*/
sw= sw - 1;  if sw//2  then sw= sw -1            /*   "    "    "     odd     "   width.*/
if rows==0  then rows= (sw - 2 ) % 3             /*pins are on the first third of screen*/
pin  = '·';            ball = '☼'                /*define chars for a  pin  and a  ball.*/
call gen                                         /*gen a triangle of pins with some rows*/
call run                                         /*simulate a Galton box with some balls*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: @.=;  do r=1  for rows;          $=         /*build a triangle of pins for the box.*/
           if r//2  then iterate                 /* [↑]  an empty odd row (with no pins)*/
                do pins=1  for r%2;   $= $  pin;  end  /*pins*/   /*build a row of pins.*/
           @.r= center( strip($, 'T'), sw)       /*an easy method to build a triangle.  */
           end     /*r*/;     #= 0;       return /*#:   is the number of balls dropped. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
drop: static= 1                                  /*used to indicate all balls are static*/
        do c=sd-1  by -1  to 1;        n= c + 1  /*D:  current row;   N:  the next row. */
        x= pos(ball, @.c);             y= x - 1  /*X:  position of a ball on the C line.*/
        if x==0  then iterate                    /*No balls here?  Then nothing to drop.*/
          do forever;   y= pos(ball, @.c, y+1)   /*drop most balls down to the next row.*/
          if y==0  then iterate c                /*down with this row, go look at next. */
          z= substr(@.n, y, 1)                   /*another ball is blocking this fall.  */
          if z==' '  then do;  @.n= overlay(ball, @.n, y)   /*drop a ball straight down.*/
                               @.c= overlay(' ' , @.c, y)   /*make current ball a ghost.*/
                               static=0                     /*indicate balls are moving.*/
                               iterate                      /*go keep looking for balls.*/
                          end
          if z==pin  then do;  ?= random(,999);   d= -1     /*assume falling to the left*/
                                    if ?//2  then d=  1     /*if odd random#, fall right*/
                               if substr(@.n, y+d, 1)\==' '  then iterate /*blocked fall*/
                               @.n= overlay(ball, @.n, y+d)
                               @.c= overlay(' ' , @.c, y  )
                               static=0                     /*indicate balls are moving.*/
                               iterate                      /*go keep looking for balls.*/
                          end
          end   /*forever*/
        end     /*c*/                  /* [↓]   step//2    is used to avoid collisions. */
                                                            /* [↓]  drop a new ball ?   */
     if #<balls & step//2  then do;    @.1= center(ball, sw+1);      # = # + 1;        end
                           else if static  then exit 2      /*insure balls are static.  */
     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: !cls;                    info= right(" step" step, sw%4)       /*title for screen.*/
               do g=sd  by -1  until @.g\=''                         /*G: last data row.*/
               end   /*g*/                                           /* [↓]  show a row.*/
        do r=1  for g;  _= strip(@.r, 'T');  if r==2  then _= _ left('', 9)  info;   say _
        end   /*r*/;    if step==freeze  then do;   say 'press ENTER ···';    pull;    end
      return
/*══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════*/
run:       do step=1;  call drop;  call show;  end  /*step*/    /*'til run out of balls.*/
halt: say '***warning***  REXX program'    !fn     "execution halted by user.";     exit 1
!all:  !!=!;!=space(!);upper !;call !fid;!nt=right(!var('OS'),2)=='NT';!cls=word('CLS VMFCLEAR CLRSCREEN',1+!cms+!tso*2);if arg(1)\==1 then return 0;if wordpos(!,'? ?SAMPLES ?AUTHOR ?FLOW')==0 then return 0;!call=']$H';call '$H' !fn !;!call=;return 1
!cal:  if symbol('!CALL')\=="VAR"  then !call=;  return !call
!env:  !env='ENVIRONMENT';  if !sys=='MSDOS' | !brexx | !r4 | !roo  then !env= 'SYSTEM';  if !os2  then !env= 'OS2'!env;  !ebcdic= 3=='f3'x;  if !crx  then !env= 'DOS';  return
!fid:  parse upper source !sys !fun !fid . 1 . . !fn !ft !fm .;  call !sys;   if !dos  then do;  _= lastpos('\', !fn);  !fm= left(!fn, _);  !fn= substr(!fn, _+1);  parse var !fn !fn '.' !ft;  end;   return word(0 !fn !ft !fm, 1 + ('0'arg(1) ) )
!rex:  parse upper version !ver !vernum !verdate .; !brexx= 'BY'==!vernum; !kexx= 'KEXX'==!ver; !pcrexx= 'REXX/PERSONAL'==!ver | 'REXX/PC'==!ver; !r4= 'REXX-R4'==!ver; !regina= 'REXX-REGINA'==left(!ver, 11); !roo= 'REXX-ROO'==!ver; call !env;  return
!sys:  !cms= !sys=='CMS';  !os2= !sys=='OS2';  !tso= !sys=='TSO' | !sys=='MVS';  !vse= !sys=='VSE';  !dos= pos('DOS', !sys)\==0 | pos('WIN', !sys)\==0 | !sys=='CMD';  !crx= left(!sys, 6)=='DOSCRX';  call !rex;  return
!var:  call !fid;  if !kexx  then return space( dosenv( arg(1) ) );              return space( value( arg(1), , !env) )
