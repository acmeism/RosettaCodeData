   real x(4), y(4)
   data x / 1.0, 2.0, 4.0, 1.0e11 /

   do 10 i = 1, 4
      y = sqrt(x)
10 continue

   open(unit=15, file='two_cols.txt', status='new')
   write(15,'(f20.3,f21.4)') (x(I), y(I), I = 1, 4)
   end
