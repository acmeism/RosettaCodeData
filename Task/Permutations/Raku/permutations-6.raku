C Output from Public domain Ratfor, version 1.0
      implicit none
      integer a(1: 3)
      integer c(1: 3)
      integer i, k
      integer tmp
10000 format ('(', i1,  2(' ', i1), ')')
      do23000 i = 1,  3
      a(i) = i
23000 continue
23001 continue
      do23002 i = 1,  3
      c(i) = 1
23002 continue
23003 continue
      i = 2
      write (*, 10000) a
23004 if(i .le.  3)then
      if(c(i) .lt. i)then
      k = mod (i, 2) + ((1 - mod (i, 2)) * c(i))
      tmp = a(i)
      a(i) = a(k)
      a(k) = tmp
      c(i) = c(i) + 1
      i = 2
      write (*, 10000) a
      else
      c(i) = 1
      i = i + 1
      endif
      goto 23004
      endif
23005 continue
      end
