program compare
integer a, b
read(*,*) a, b

if (a .lt. b) then
  write(*, *) a, ' is less than ', b
else if (a .eq. b) then
  write(*, *) a, ' is equal to ', b
else if (a .gt. b) then
  write(*, *) a, ' is greater than ', b
end if

end
