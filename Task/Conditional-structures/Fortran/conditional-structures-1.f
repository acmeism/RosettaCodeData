if ( a .gt. 20.0 ) then
   q = q + a**2
else if ( a .ge. 0.0 ) then
   q = q + 2*a**3
else
   q = q - a
end if
