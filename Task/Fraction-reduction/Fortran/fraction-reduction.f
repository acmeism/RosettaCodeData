! Fraction reduction
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program digit_cancel
  implicit none

  integer, dimension(4,2) :: lims
  integer, dimension(4)   :: count
  integer, dimension(4,10):: omitted

  integer :: i, j, n, d
  integer :: nix, dix, digit
  integer :: rn, rd
  integer :: le
  logical :: nOk, dOk

  integer, allocatable :: nDigits(:)
  integer, allocatable :: dDigits(:)

  lims(1,:) = [12,    97]
  lims(2,:) = [123,   986]
  lims(3,:) = [1234,  9875]
  lims(4,:) = [12345, 98764]

  count   = 0
  omitted = 0

  do i = 1, size(lims,1)

    le = i + 1

    allocate(nDigits(le))
    allocate(dDigits(le))

    do n = lims(i,1), lims(i,2)

      nDigits = 0
      nOk = getDigits(n, le, nDigits)
      if (.not. nOk) cycle

      do d = n + 1, lims(i,2) + 1

        dDigits = 0
        dOk = getDigits(d, le, dDigits)
        if (.not. dOk) cycle

        do nix = 1, le

          digit = nDigits(nix)
          dix = indexOf(dDigits, digit)

          if (dix >= 1) then

            rn = removeDigit(nDigits, le, nix)
            rd = removeDigit(dDigits, le, dix)

            if (rd /= 0) then
!             Use integer multiplication instead of floating point division
              if (n*rd == rn*d) then
                count(i) = count(i) + 1
                omitted(i, digit) = omitted(i, digit) + 1

                if (count(i) <= 12) then
                  write(*,'(i0,"/",i0," = ",i0,"/",i0," by omitting ",i0,"''s")') &
                    n, d, rn, rd, digit
                end if

              end if
            end if

          end if

        end do
      end do
    end do

    write(*,*)

    deallocate(nDigits, dDigits)

  end do


  do i = 2, 5

    write(*,'("There are ",i0," ",i0,"-digit fractions of which:")') count(i-1), i

    do j = 1, 9
      if (omitted(i-1,j) == 0) cycle
      write(*,'(i6," have ",i0,"''s omitted")') omitted(i-1,j), j
    end do

    write(*,*)
  end do


contains


  integer function indexOf(haystack, needle)
    implicit none
    integer, intent(in) :: haystack(:)
    integer, intent(in) :: needle
    integer :: k

    indexOf = -1

    do k = 1, size(haystack)
      if (haystack(k) == needle) then
        indexOf = k
        return
      end if
    end do
  end function indexOf



  logical function getDigits(n, le, digits)
    implicit none
    integer, intent(in)    :: n, le
    integer, intent(inout) :: digits(:)

    integer :: tmp, r, pos

    tmp = n
    pos = le

    do while (tmp > 0)

      r = mod(tmp, 10)

      if (r == 0 .or. indexOf(digits, r) >= 1) then
        getDigits = .false.
        return
      end if

      digits(pos) = r
      pos = pos - 1
      tmp = tmp / 10

    end do

    getDigits = .true.
  end function getDigits



  integer function removeDigit(digits, le, idx)
    implicit none
    integer, intent(in) :: digits(:)
    integer, intent(in) :: le, idx

    integer, dimension(5) :: pows = [1,10,100,1000,10000]
    integer :: i, pow, sum

    sum = 0

    ! Important: le-1 and NOT le-2 (C++ 0-based vs Fortran 1-based)
    pow = pows(le-1)

    do i = 1, le
      if (i == idx) cycle
      sum = sum + digits(i) * pow
      pow = pow / 10
    end do

    removeDigit = sum
  end function removeDigit


end program digit_cancel
