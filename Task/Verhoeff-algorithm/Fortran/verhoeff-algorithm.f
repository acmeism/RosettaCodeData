module verhoeff_mod
   implicit none

   !----------------------------------------------------------------
   ! Zero-based Verhoeff tables d, inv, p
   !----------------------------------------------------------------
   integer, parameter :: d1 = 10, d2 = 10
   integer, parameter :: d(0:d1 - 1, 0:d2 - 1) = reshape([ &
   ! 10 rows of 10 ints each — exactly as in VB,
   ! listed row-major so we use ORDER=[2,1] below
         0, 1, 2, 3, 4, 5, 6, 7, 8, 9, &
         1, 2, 3, 4, 0, 6, 7, 8, 9, 5, &
         2, 3, 4, 0, 1, 7, 8, 9, 5, 6, &
         3, 4, 0, 1, 2, 8, 9, 5, 6, 7, &
         4, 0, 1, 2, 3, 9, 5, 6, 7, 8, &
         5, 9, 8, 7, 6, 0, 4, 3, 2, 1, &
         6, 5, 9, 8, 7, 1, 0, 4, 3, 2, &
         7, 6, 5, 9, 8, 2, 1, 0, 4, 3, &
         8, 7, 6, 5, 9, 3, 2, 1, 0, 4, &
         9, 8, 7, 6, 5, 4, 3, 2, 1, 0 ], shape=[d1, d2], order=[2, 1])

   integer, parameter :: inv(0:d1 - 1) = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]

   integer, parameter :: r = 8, c = 10
   integer, parameter :: p(0:r - 1, 0:c - 1) = reshape([ &
         0, 1, 2, 3, 4, 5, 6, 7, 8, 9, &
         1, 5, 7, 6, 2, 8, 3, 0, 9, 4, &
         5, 8, 0, 3, 7, 9, 6, 1, 4, 2, &
         8, 9, 1, 6, 0, 4, 3, 5, 2, 7, &
         9, 4, 5, 3, 1, 2, 6, 8, 7, 0, &
         4, 2, 8, 6, 5, 7, 3, 9, 0, 1, &
         2, 7, 9, 3, 8, 0, 6, 4, 1, 5, &
         7, 0, 4, 6, 9, 1, 3, 2, 5, 8 ], shape=[r, c], order=[2, 1])

contains

   !----------------------------------------------------------------
   !  verhoeff()
   !    s        : input digit-string
   !    validate : .TRUE. for check, .FALSE. to compute digit
   !    table    : .TRUE. to dump tables,  .FALSE. to skip
   !  returns
   !    if(validate)  1=>valid, 0=>invalid
   !    if(.not.validate) the computed check digit (0–9)
   !----------------------------------------------------------------
   function verhoeff(s, validate, table) result(res)
      implicit none
      character(len=*), intent(in) :: s
      logical, intent(in) :: validate, table
      integer :: res

      integer :: c, lens, k, digit, pi
      character(len=:), allocatable :: str
      res = 0

      ! Append '0' when generating the check digit
      if (.not.validate) then
         str = trim(s) // '0'
      else
         str = trim(s)
      end if
      lens = len_trim(str)
      c = 0

      ! Main Verhoeff loop: right-to-left over str
      do k = lens, 1, -1
         digit = ichar(str(k:k)) - ichar('0')
         pi = p(mod(lens - k, size(p, 1)), digit)
         c = d(c, pi)
         if (table) then
            write(*, '(I2,1X,I2,2X,I2,2X,I2)') lens - k, digit, pi, c
         end if
      end do

      if (.not.validate) then
         ! computing check digit
         res = inv(c)
      else
         ! validating: success only if c==0
         res = merge(1, 0, c == 0)
      end if

   end function verhoeff

end module verhoeff_mod

program test_verhoeff
   use verhoeff_mod
   implicit none

   character(len=20), parameter :: inputs(3) = [character(len=20) :: '236', '12345', '123456789012' ]
   logical, parameter :: showtable(3) = [ .true., .true., .false. ]

   integer :: i, chk, ok
   character(len=:), allocatable :: withchk, with9

   do i = 1, 3
      ! Compute the check digit
      chk = verhoeff(inputs(i), .false., showtable(i))
      write(*, '(3A,I1)') 'Check digit for "', trim(inputs(i)), '" is ', chk

      ! Test two variants: one with the computed digit, one with '9'
      withchk = trim(inputs(i)) // achar(ichar('0') + chk)
      with9 = trim(inputs(i)) // '9'

      ok = verhoeff(withchk, .true., showtable(i))
      write(*, '(4A)') 'Validation for "', trim(withchk), '" : ', &
            merge(' correct ', 'incorrect', ok == 1)

      ok = verhoeff(with9, .true., showtable(i))
      write(*, '(4A)') 'Validation for "', trim(with9), '" : ', &
            merge(' correct ', 'incorrect', ok == 1)

      write(*, *)
   end do

end program test_verhoeff
