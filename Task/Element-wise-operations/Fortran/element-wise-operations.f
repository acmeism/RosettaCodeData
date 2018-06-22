program element_operations
  implicit none

  real(kind=4), dimension(3,3) :: a,b
  integer :: i

  a=reshape([(i,i=1,9)],shape(a))

  print*,'addition'
  b=a+a
  call print_arr(b)

  print*,'multiplication'
  b=a*a
  call print_arr(b)

  print*,'division'
  b=a/b
  call print_arr(b)

  print*,'exponentiation'
  b=a**a
  call print_arr(b)

  print*,'trignometric'
  b=cos(a)
  call print_arr(b)

  print*,'mod'
  b=mod(int(a),3)
  call print_arr(b)

  print*,'element selection'
  b=0
  where(a>3) b=1
  call print_arr(b)

  print*,'elemental functions can be applied to single values:'
  print*,square(3.0)
  print*,'or element wise to arrays:'
  b=square(a)
  call print_arr(b)


contains

  elemental real function square(a)
    real, intent(in) :: a
    square=a*a
  end function square

  subroutine print_arr(arr)
    real, intent(in) :: arr(:,:)
    integer :: i
    do i=1,size(arr,dim=2)
       print*,arr(:,i)
    end do
  end subroutine print_arr


end program element_operations
