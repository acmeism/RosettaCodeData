      program writefloats
      integer i
      double precision x(4), y(4)
      data x /1d0, 2d0, 4d0, 1d11/

      do 10 i = 1, 4
      y = sqrt(x)
   10 continue

      open(unit=15, file='two_cols.txt', status='new')
      write(15, '(f20.3,f21.4)') (x(i), y(i), i = 1, 4)
      end
