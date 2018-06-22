/*REXX program  displays  the  moves  to solve  the  Tower of Hanoi  (with  N  disks).  */
parse arg N .                                    /*get optional number of disks from CL.*/
if N=='' | N==","  then N=3                      /*Not specified?  Then use the default.*/
sw=80;     wp=sw%3-1;     blanks=left('', wp)    /*define some default REXX variables.  */
c.1= sw % 3 % 2                                  /* [↑]  SW: assume default Screen Width*/
c.2= sw % 2 - 1
c.3= sw - 1 - c.1
#=0;       z=2**N-1;      moveK=z                /*#moves; min# of moves; where to move.*/
@abc='abcdefghijklmnopqrstuvwxyN'                /*dithering chars when many disks used.*/
ebcdic= ('f0'x==0)                               /*determine if EBCDIC or ASCII machine.*/

if ebcdic then do;   bar= 'bf'x;    ar= "df"x;     boxen= 'db9f9caf'x;         down= "9a"x
                      tr= 'bc'x;    bl= "ab"x;     br= 'bb'x;   vert= "fa"x;     tl= 'ac'x
               end
          else do;   bar= 'c4'x;    ar= "10"x;     boxen= 'b0b1b2db'x;         down= "18"x
                      tr= 'bf'x;    bl= "c0"x;     br= 'd9'x;   vert= "b3"x;     tl= 'da'x
               end

verts= vert || vert;       Tcorners=    tl || tr
downs= down || down;       Bcorners=    bl || br
box  = left(boxen, 1);     boxChars= boxen || @abc
$.=0;    $.1=N;    k=N;    kk=k+k

  do j=1  for N;   @.3.j=blanks;     @.2.j=blanks;     @.1.j=center( copies( box, kk), wp)
  if N<=length(boxChars)  then @.1.j= translate(@.1.j, , substr( boxChars, kk%2, 1), box)
  kk=kk - 2
  end   /*j*/                                    /*populate the tower of Hanoi spindles.*/

call showTowers;   call mov 1,3,N;   say
say 'The minimum number of moves to solve a '      N"-disk  Tower of Hanoi is "      z
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
dsk: parse arg from dest;  #=#+1;  pp=
     if from==1  then do;  pp=overlay(bl,  pp, c.1)
                           pp=overlay(bar, pp, c.1+1, c.dest-c.1-1, bar) || tr
                      end
     if from==2  then do
                      lpost=min(2, dest)
                      hpost=max(2, dest)
                      if dest==1  then do;  pp=overlay(tl,  pp, c.1)
                                            pp=overlay(bar, pp, c.1+1, c.2-c.1-1, bar)||br
                                       end
                      if dest==3  then do;  pp=overlay(bl,  pp, c.2)
                                            pp=overlay(bar, pp, c.2+1, c.3-c.2-1, bar)||tr
                                       end
                      end
     if from==3  then do;  pp=overlay(br,  pp, c.3)
                           pp=overlay(bar, pp, c.dest+1, c.3-c.dest-1, bar)
                           pp=overlay(tl,  pp, c.dest)
                      end
     say translate(pp, downs, Bcorners || Tcorners || bar);    say overlay(moveK,pp,1)
     say translate(pp, verts, Tcorners || Bcorners || bar)
     say translate(pp, downs, Tcorners || Bcorners || bar);    moveK=moveK-1
     $.from=$.from-1;      $.dest=$.dest+1;    _f=$.from+1;    _t=$.dest
     @.dest._t=@.from._f;  @.from._f=blanks;   call showTowers
     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
mov: if arg(3)==1  then call dsk arg(1) arg(2)
                   else do;  call mov arg(1),          6-arg(1)-arg(2), arg(3)-1
                             call mov arg(1),          arg(2),          1
                             call mov 6-arg(1)-arg(2), arg(2),          arg(3)-1
                        end
     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showTowers: do j=N  by -1  for N; _=@.1.j @.2.j @.3.j;  if _\=''  then say _; end;  return
