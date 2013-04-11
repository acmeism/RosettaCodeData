/*REXX program shows pictorial moves to solve Tower of Hanoi (3 disks). */
arg z .;  if z=='' then z=3
sw=80;   wp=sw%3-1;   blanks=centre('',wp)
c.1=sw%3%2
c.2=sw%2-1
c.3=sw-1-c.1-1
move=0;   totmoves=2**z-1;   movek=totmoves;   lentot=length(totmoves)
@abc='abcdefghijklmnopqrstuvwxyz'
ebcdic= 'f0'x==0
if ebcdic then do
               bar='bf'x;ar='df'x;boxen='db9f9caf'x;tl='ac'x;tr='bf'x;bl='ab'x;br='bb'x;vert='fa'x;down='9a'x
               end
          else do
               bar='c4'x;ar='10'x;boxen='b0b1b2db'x;tl='da'x;tr='bf'x;bl='c0'x;br='d9'x;vert='b3'x;down='19'x
               end
verts=vert || vert
downs=down || down
Tcorners=tl || tr
Bcorners=bl || br
box=left(boxen,1);   boxchars=boxen || @abc
bararrow=bar || bar || ar
$.=0;  $.1=z;  k=z;  kk=k+k

  do j=1 for z
  @.3.j=blanks;   @.2.j=blanks
  @.1.j=centre(copies(box,kk),wp)
  if z<=length(boxchars) then @.1.j=,
                              translate(@.1.j,substr(boxchars,kk%2,1),box)
  kk=kk-2
  end   /*j*/

call showtowers;   call mov 1,3,z
say
say "The minimum number of moves for a" z 'ring Tower of Hanoi is' totmoves
exit
/*─────────────────────────────MOV subroutine───────────────────────────*/
mov: if arg(3)==1 then call rng arg(1) arg(2)
                  else do
                       call mov arg(1),6-arg(1)-arg(2),arg(3)-1
                       call mov arg(1),arg(2),1
                       call mov 6-arg(1)-arg(2),arg(2),arg(3)-1
                       end
return
/*─────────────────────────────RNG subroutine───────────────────────────*/
rng: parse arg from dest;  move=move+1;  pp=
if from==1 then do
                pp=overlay(bl,pp,c.1)
                pp=overlay(bar,pp,c.1+1,c.dest-c.1-1,bar)
                pp=pp || tr
                end
if from==3 then do
                pp=overlay(br,pp,c.3)
                pp=overlay(bar,pp,c.dest+1,c.3-c.dest-1,bar)
                pp=overlay(tl,pp,c.dest)
                end
if from==2 then do
                lpost=min(2,dest)
                hpost=max(2,dest)
                if dest==1 then do
                                pp=overlay(tl,pp,c.1)
                                pp=overlay(bar,pp,c.1+1,c.2-c.1-1,bar)
                                pp=pp || br
                                end
                if dest==3 then do
                                pp=overlay(bl,pp,c.2)
                                pp=overlay(bar,pp,c.2+1,c.3-c.2-1,bar)
                                pp=pp || tr
                                end
                end
say translate(pp,verts,Bcorners||Tcorners||bar);  say overlay(movek,pp,1)
say translate(pp,verts,Tcorners||Bcorners||bar)
say translate(pp,downs,Tcorners||Bcorners||bar)
movek=movek-1
$.from=$.from-1;       $.dest=$.dest+1;    _f=$.from+1;    _t=$.dest
@.dest._t=@.from._f;   @.from._f=blanks
call showtowers
return
/*─────────────────────────────SHOWTOWERS subroutine────────────────────*/
showtowers:   do j=z to 1 by -1
              _p=@.1.j  @.2.j  @.3.j;   if _p\='' then say _p
              end    /*j*/
return
