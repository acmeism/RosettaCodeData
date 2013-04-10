      program test
C
C--   Declare array:
      integer a(5)
C
C--   Fill it with Data
      data a /45,22,67,87,98/
C
C--   Do something with all elements (in this case: print their squares)
      do i=1,5
        print *,a(i)*a(i)
      end do
C
      end
