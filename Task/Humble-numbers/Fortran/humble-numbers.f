! Humble Numbers
! tested with GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!
! Note that both intel ifx and VSI Fortran do not compile this code because they cannot
! deal with 16-byte-integers.
!
! U.B., July 2025
!


program humbleNumbers

implicit none

integer, parameter :: int_kind = 16             ! Fortran compilers other than gfortran can't handle this
integer, parameter :: printLimit = 50           ! need to print first 50 humble numbers

integer                 :: max_digits = 38      ! (signed) Integer(kind=16) can carry 38 digits
integer, parameter      :: maxhSize=1160000     ! array size for all stored humble numbers
integer (kind=int_kind) :: humble ( maxhSize )  ! the humble numbers
integer                 :: usedH = 1            ! highest index into humble
integer (kind=int_kind) :: powersOf2=2, powersOf3=3,powersOf5=5,powersOf7=7,currentHumble=2, lim=10
integer                  :: i=1, j=1,k=1,m=1,lastCount=0,d=1

humble (1) = 1

do while (.true.)

  usedH = usedH + 1
  if (usedH .le. maxhSize) then           ! B sure we dont crash.
    humble (usedH) = currentHumble
  else
    exit                                  ! otherwise terminate.
  endif

  ! construct next humble number as 2^i* 3^j * 5^k * 7^m
  !
  ! What comes next?
  if (currentHumble .eq. powersOf2) then
    i = i + 1
    powersOf2 = humble (i) * 2
  endif
  if (currentHumble .eq. powersOf3) then
    j = j + 1
    powersOf3 = humble (j) * 3
  endif
  if (currentHumble .eq. powersOf5) then
    k = k + 1
    powersOf5 = humble (k) * 5
  endif
  if (currentHumble .eq. powersOf7) then
    m = m + 1
    powersOf7 = humble (m) * 7
  endif
  currentHumble = powersOf2

  ! Select next larger humble number
  if (powersOf3<currentHumble) currentHumble=powersOf3
  if (powersOf5<currentHumble) currentHumble=powersOf5
  if (powersOf7<currentHumble) currentHumble=powersOf7

  if (currentHumble >=lim) then       ! another digit ?
    write (6, '(I0, " digits: ", i0)') d,  usedH -lastCount
    lastCount = usedH
    d = d + 1

    if (d .gt. max_digits) then       ! Maximum number of digits reached, terminate.
      exit
    endif
    lim = lim * 10                    ! to detect next larger number of digits
  endif
enddo

write (6, '(/"total =   ", I0 )')   usedH
write (6,'(/"The first " ,I0, " humble numbers are:" )')  printLimit
do i=1,printLimit
  write (6,'(X, I0)', advance='no')   humble (i)
enddo
write (6,*) ! terminate last output line.

end program humbleNumbers
