      program IdentStr
          implicit none
          integer n, concat, bits

          n = 1
  100     if (concat(n) .lt. 1000) then
              write (*,'(I3,2X,I11)') concat(n), bits(concat(n))
              n = n + 1
              goto 100
          end if
          stop
      end

C     Concatenate binary representation of number with itself
      integer function concat(num)
          integer num, sl, sr
          sl = num
          sr = num
  100     if (sr .gt. 0) then
              sl = sl * 2
              sr = sr / 2
              goto 100
          end if
          concat = num + sl
      end

C     Calculate binary representation of number
      integer function bits(num)
          integer num, n, bx
          n = num
          bits = 0
          bx = 1
  100     if (n .gt. 0) then
              bits = bits + bx * mod(n,2)
              bx = bx * 10
              n = n / 2
              goto 100
          end if
      end
