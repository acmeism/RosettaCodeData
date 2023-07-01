program multiple
  ! Define a simple type
  type T
     integer :: a = 3
  end type T

  ! Define a type containing a pointer
  type S
     integer, pointer :: a
  end type S

  type(T), allocatable :: T_array(:)
  type(S), allocatable :: S_same(:)
  integer              :: i
  integer, target      :: v
  integer, parameter   :: N = 10

  ! Create 10
  allocate(T_array(N))

  ! Set the fifth one to b something different
  T_array(5)%a = 1

  ! Print them out to show they are distinct
  write(*,'(10i2)') (T_array(i),i=1,N)

  ! Create 10 references to the same object
  allocate(S_same(N))
  v = 5
  do i=1, N
     allocate(S_same(i)%a)
     S_same(i)%a => v
  end do

  ! Print them out - should all be 5
  write(*,'(10i2)') (S_same(i)%a,i=1,N)

  ! Change the referenced object and reprint - should all be 3
  v = 3
  write(*,'(10i2)') (S_same(i)%a,i=1,N)

end program multiple
