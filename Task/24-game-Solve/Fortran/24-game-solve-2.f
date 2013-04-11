module helpers

contains

  pure subroutine Insertion_Sort(a)
    integer, intent(inout) :: a(:)
    integer                :: temp, i, j
    do i=2,size(a)
      j = i-1
      temp = a(i)
      do while ( j>=1 .and. a(j)>temp )
        a(j+1) = a(j)
        j = j - 1
      end do
      a(j+1) = temp
    end do
  end subroutine Insertion_Sort

  subroutine nextpermutation(perm,last)
    integer, intent(inout) :: perm(:)
    logical, intent(out)   :: last
    integer :: k,l
    k = largest1()
    last = k == 0
    if ( .not. last ) then
      l = largest2(k)
      call swap(l,k)
      call reverse(k)
    end if
  contains
    pure integer function largest1()
      integer :: k, max
      max = 0
      do k=1,size(perm)-1
        if ( perm(k) < perm(k+1) ) then
          max = k
        end if
      end do
      largest1 = max
    end function largest1

    pure integer function largest2(k)
      integer, intent(in) :: k
      integer             :: l, max
      max = k+1
      do l=k+2,size(perm)
        if ( perm(k) < perm(l) ) then
          max = l
        end if
      end do
      largest2 = max
    end function largest2

    subroutine swap(l,k)
      integer, intent(in) :: k,l
      integer             :: temp
      temp    = perm(k)
      perm(k) = perm(l)
      perm(l) = temp
    end subroutine swap

    subroutine reverse(k)
      integer, intent(in) :: k
      integer             :: i
      do i=1,(size(perm)-k)/2
        call swap(k+i,size(perm)+1-i)
      end do
    end subroutine reverse

  end subroutine nextpermutation

end module helpers
