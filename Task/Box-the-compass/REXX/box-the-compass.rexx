/*REXX program  "boxes the compass"    (from º headings ───►  a 32 point set).*/
parse arg #                              /*allow a  º heading to be specified.*/
if #=''  then #= 0 16.87 16.88 33.75 50.62 50.63 67.5 84.37 84.38 101.25 118.12,
                 118.13 135 151.87 151.88 168.75 185.62 185.63 202.5 219.37,
                 219.38 236.25 253.12 253.13 270 286.87 286.88 303.75 320.62,
                 320.63 337.5 354.37 354.38    /* [↑]  use default in degrees.*/

points= 'n nbe n-ne nebn ne nebe e-ne ebn e ebs e-se sebe se sebs s-se sbe',
        's sbw s-sw swbs sw swbw w-sw wbs w wbn w-nw nwbw nw nwbn n-nw nbw'

dirs= 'north south east west'            /*define cardinal compass directions.*/
                                         /* [↓]  choose a degree  (°)  glyph. */
if 4=='f4'x  then degSym='a1'x           /*is this system an  EBCDIC  system? */
             else degSym='f8'x           /*although 'a7'x looks better: ° vs º*/
                                         /*─────────────────────────── f8   a7*/
say right(degSym'heading',30)   center('compass heading',20)
say right(     '────────',30)   copies('─'              ,20)

        do j=1  for words(#);   x=word(#,j)   /*get one of the degree headings*/
        say right(format(x,,2)degSym,30-1)    ' '    boxHeading(x)
        end   /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
boxHeading: _=arg(1)//360;  if _<0 then _=360-_       /*normalize the heading.*/
_=word(points,trunc(max(1,(_/11.25+1.5)//33)))
                                     do k=1  for words(dirs);    d=word(dirs,k)
                                     _=changestr(left(d,1), _, d)
                                     end   /*k*/
return changestr('b', _, " by ")                      /*expand  "b"  ──►  "by"*/
