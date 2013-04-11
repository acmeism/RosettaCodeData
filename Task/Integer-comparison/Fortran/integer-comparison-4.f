program compare
integer :: a, b
read(*,*) a, b

if (a < b) then
  write(*, *) a, ' is less than ', b
else if (a == b) then
  write(*, *) a, ' is equal to ', b
else if (a > b) then
  write(*, *) a, ' is greater than ', b
end if

end program compare
