program pi
  implicit none
  integer,dimension(3350) :: vect
  integer,dimension(201) :: buffer
  integer :: more,karray,num,k,l,n
  more = 0
  vect = 2
  do n = 1,201
    karray = 0
    do l = 3350,1,-1
      num = 100000*vect(l) + karray*l
      karray = num/(2*l - 1)
      vect(l) = num - karray*(2*l - 1)
    end do
    k = karray/100000
    buffer(n) = more + k
    more = karray - k*100000
  end do
  write (*,'(i2,"."/(1x,10i5.5))') buffer
end program pi
