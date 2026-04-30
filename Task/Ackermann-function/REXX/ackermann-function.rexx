-- 27 Oct 2025
include Setting
numeric digits 310000

say 'ACKERMANN FUNCTION'
say version
say
call Ackermann1
call Ackermann2
exit

Ackermann1:
procedure expose glob.
say 'Using recursion...'
do i=0 to 3
   do j=0 to 10
      say 'Ackermann('i','j')' '=' Acker1(i,j) Elaps('r')'s'
   end
end
say
return

Acker1:
procedure
arg xx,yy
select
   when xx = 0 then
      return yy+1
   when yy = 0 then
      return Acker1(xx-1,1)
   otherwise
      return Acker1(xx-1,Acker1(xx,yy-1))
end

Ackermann2:
procedure expose glob.
say 'Using closed formulas...'
do i=0 to 3
   do j=0 to 10
      say 'Ackermann('i','j')' '=' Acker2(i,j) Elaps('r')'s'
   end
end
say 'Ackermann(3,100) =' Acker2(3,100) Elaps('r')'s'
say 'Ackermann(3,1000) has' Length(Acker2(3,1000)) 'digits' Elaps('r')'s'
say 'Ackermann(3,10000) has' Length(Acker2(3,10000)) 'digits' Elaps('r')'s'
say 'Ackermann(3,100000) has' Length(Acker2(3,100000)) 'digits' Elaps('r')'s'
say 'Ackermann(3,1000000) has' Length(Acker2(3,1000000)) 'digits' Elaps('r')'s'
say 'Ackermann(4,0) =' Acker2(4,0) Elaps('r')'s'
say 'Ackermann(4,1) =' Acker2(4,1) Elaps('r')'s'
say 'Ackermann(4,2) has' Length(Acker2(4,2)) 'digits' Elaps('r')'s'
return

Acker2:
procedure
arg xx,yy
select
   when xx=0 then
      rr=yy+1
   when xx=1 then
      rr=yy+2
   when xx=2 then
      rr=yy+yy+3
   when xx=3 then
      rr=2**(yy+3)-3
   when xx=4 then
      select
         when yy=0 then
            rr=2**(2**2)-3
         when yy=1 then
            rr=2**(2**(2**2))-3
         when yy=2 then
            rr=2**(2**(2**(2**2)))-3
         otherwise
            rr=0
      end
   otherwise
      rr=0
end
return rr

include Abend
-- Elaps
include Timer
