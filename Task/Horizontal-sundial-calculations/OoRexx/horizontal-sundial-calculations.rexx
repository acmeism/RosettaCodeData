/*REXX pgm shows:  hour,  sun hour angle,  dial hour line angle,  6am ---> 6pm*/
/* Use trigonometric functions provided by rxCalc                             */
parse arg lat lng mer .               /*get the optional arguments from the CL*/
                          /*None specified?   Then use the default of Jules   */
                          /*Verne's Lincoln Island,  aka  Ernest Legouve Reef.*/

if lat=='' | lat==',' then lat=-4.95  /*Not specified?   Then use the default.*/
if lng=='' | lng==',' then lng=-150.5 /* "      "          "   "   "     "    */
if mer=='' | mer==',' then mer=-150   /* "      "          "   "   "     "    */
L=max(length(lat), length(lng), length(mer))
say '       latitude:' right(lat,L)
say '      longitude:' right(lng,L)
say ' legal meridian:' right(mer,L)
sineLat=rxCalcSin(lat,,'D')
w1=max(length('hour')     ,length('midnight'))+2
w2=max(length('sun hour') ,length('angle'))+2
w3=max(length('dial hour'),length('line angle'))+2
indent=left('',30)               /*make the presentation prettier.      */
say indent center('    ',w1) center('sun hour',w2) center('dial hour' ,w3)
say indent center('hour',w1) center('angle'   ,w2) center('line angle',w3)
call sep                         /*add a separator line for the eyeballs*/

do h=-6  to 6                    /*Okey dokey then, let's get busy.     */
  select
    when abs(h)==12  then hc='midnight'      /*above the arctic circle? */
    when h<0  then hc=-h 'am'    /*convert the hour for human beans.    */
    when h==0 then hc='noon'     /*  ... easier to understand now.      */
    when h>0  then hc=h 'pm'     /*  ... even more meaningful.          */
    end   /*select*/
  hra=15*h-lng+mer
  hla=rxCalcArctan(sineLat*rxCalctan(hra,,'D'),,'D')
  say indent center(hc,w1) right(format(hra,,1),w2) right(format(hla,,1),w3)
  end
call sep
Exit
sep: say indent copies('-',w1) copies('-',w2) copies('-',w3)
     Return
::Requires rxMath Library
