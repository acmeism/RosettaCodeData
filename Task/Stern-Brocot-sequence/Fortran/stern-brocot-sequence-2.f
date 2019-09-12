 ! Stern-Brocot sequence - Fortran 90
      parameter (nn=2400)
      dimension isb(nn)
      isb(1)=1; isb(2)=1
      i=1; j=2; k=2
      do while(k.lt.nn)
        k=k+1; isb(k)=isb(k-i)+isb(k-j)
        k=k+1; isb(k)=isb(k-j)
        i=i+1; j=j+1
      end do
      n=15
      write(*,"(1x,'First',i4)") n
      write(*,"(15i4)") (isb(i),i=1,15)
      do j=1,11
        jj=j
        if(j==11) jj=100
        do i=1,k
          if(isb(i)==jj) exit
        end do
        write(*,"(1x,'First',i4,' at ',i4)") jj,i
      end do
      end
