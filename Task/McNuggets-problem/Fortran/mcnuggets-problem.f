program mcnugget
  ! Program to find non-McNugget numbers (up to 100) that cannot be expressed as
  ! 6x + 9y + 20z (with x, y, z non-negative integers). This version uses dynamic
  ! programming to mark expressible numbers and then uses FINDLOC on a logical mask
  ! (derived by applying .NOT. to the expressible array) to obtain the largest
  ! non-expressible number.

  implicit none
  integer, parameter :: n = 100
  logical :: expressible(0:n)  ! Mark if each number 0:n is expressible.
  integer :: max_val           ! To store the largest non-expressible number.
  integer :: i, j            ! Loop indices.
  integer :: denoms(3)         ! Array of denominations: 6, 9, 20.
  integer, allocatable :: loc(:)
  ! 'loc' will store the indices returned by FINDLOC.

  !--------------------------------------------------------------------
  ! Initialize the denominations and print them.
  !--------------------------------------------------------------------
  denoms = [6, 9, 20]
  print *, 'Nugget pacet sizes: ', denoms

  !--------------------------------------------------------------------
  ! Initialize all numbers as non-expressible except 0.
  ! 0 is expressible (with x = y = z = 0).
  !--------------------------------------------------------------------
  expressible = .false.
  expressible(0) = .true.

  !--------------------------------------------------------------------
  ! Dynamic programming:
  ! For each denomination, if a number i is expressible then mark
  ! i + denomination as expressible (provided it does not exceed n).
  !--------------------------------------------------------------------
  do j = 1, 3
    do i = 0, n - denoms(j)
      if (expressible(i)) then
        expressible(i + denoms(j)) = .true.
      end if
    end do
  end do

  !--------------------------------------------------------------------
  ! Instead of looping to count and store non-expressible numbers,
  ! we use the FINDLOC intrinsic to get the largest index for which
  ! the number is NOT expressible.
  !
  ! The expression (.not. expressible) creates a logical mask that is .true.
  ! when a number is non-expressible. FINDLOC with BACK=.TRUE. searches the
  ! array in reverse order (from n down to 0), thus returning the maximum index.
  !--------------------------------------------------------------------
  loc = findloc(.not. expressible, .true., back = .true.)
  if (size(loc) > 0) then
    max_val = loc(1)  ! Retrieve the largest non-expressible number.
  else
    max_val = 0       ! In the unlikely event that every number is expressible.
  end if

  !--------------------------------------------------------------------
  ! Output the result (only the largest non-McNugget number).
  !--------------------------------------------------------------------
  print *, 'Maximum non-McNuggets number is ', max_val

end program mcnugget
