program test_maxval

integer,dimension(5),parameter :: x = [10,100,7,1,2]
real,dimension(5),parameter :: y = [5.0,60.0,1.0,678.0,0.0]

write(*,'(I5)') maxval(x)
write(*,'(F5.1)') maxval(y)

end program test_maxval
