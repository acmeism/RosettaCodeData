program routh_hurwitz
  !  Routh-Hurwitz Stability Criterion
  !  Builds the Routh array for a polynomial and counts sign changes
  !  in the first column to determine stability of an LTI system.
  !
  !  Special cases handled:
  !    1) Zero in first column (not entire row) -> epsilon substitution
  !    2) Entire zero row -> replace with derivative of auxiliary polynomial

  implicit none

  !  Test polynomials
  call analyze("s^3 + 6s^2 + 11s + 6", &
               [1.0d0, 6.0d0, 11.0d0, 6.0d0])

  call analyze("s^3 + 6s^2 + 11s - 6", &
               [1.0d0, 6.0d0, 11.0d0, -6.0d0])

  call analyze("s^6 + 2s^5 + 8s^4 + 12s^3 + 20s^2 + 16s + 16", &
               [1.0d0, 2.0d0, 8.0d0, 12.0d0, 20.0d0, 16.0d0, 16.0d0])

  call analyze("s^3 + s^2 + s + 1", &
               [1.0d0, 1.0d0, 1.0d0, 1.0d0])

  call analyze("s^5 + 2s^4 + 3s^3 + 6s^2 + 5s + 10", &
               [1.0d0, 2.0d0, 3.0d0, 6.0d0, 5.0d0, 10.0d0])

  call analyze("2s^2 + 4s + 2", &
               [2.0d0, 4.0d0, 2.0d0])

contains

  ! ------------------------------------------------------------------
  subroutine analyze(poly_name, a)
  ! ------------------------------------------------------------------
    character(len=*), intent(in) :: poly_name
    real(8),          intent(in) :: a(:)

    real(8), parameter :: EPS = 1.0d-10

    integer  :: n, ncols, nrows, i, j
    real(8), allocatable :: R(:,:)
    real(8)  :: pivot, cur_sign, prev_sign
    integer  :: sign_changes
    logical  :: marginal

    n     = size(a) - 1           ! polynomial degree
    nrows = n + 1                 ! one row per power s^n .. s^0
    ncols = (n + 2) / 2           ! ceiling((n+1)/2)

    allocate(R(0:nrows-1, 0:ncols-1))
    R = 0.0d0

    ! ---- Fill first two rows ----------------------------------------
    !  Row 0  (s^n   row): a0, a2, a4, ...
    !  Row 1  (s^n-1 row): a1, a3, a5, ...
    do j = 0, ncols-1
      if (2*j     <= n) R(0, j) = a(2*j + 1)
      if (2*j + 1 <= n) R(1, j) = a(2*j + 2)
    end do

    marginal = .false.

    ! ---- Build remaining rows ---------------------------------------
    do i = 2, nrows-1

      !  If pivot element is zero, apply epsilon substitution
      pivot = R(i-1, 0)
      if (abs(pivot) < EPS) then
        pivot = EPS
        R(i-1, 0) = EPS
      end if

      !  Standard Routh row formula
      do j = 0, ncols-2
        R(i, j) = (pivot * R(i-2, j+1) - R(i-2, 0) * R(i-1, j+1)) / pivot
      end do
      !  Last column is always zero (already initialised)

      !  Detect all-zero row (auxiliary polynomial case), skip last row
      if (i < nrows-1 .and. all(abs(R(i,:)) < EPS)) then
        marginal = .true.
        !  Auxiliary polynomial P_aux comes from row i-1 which corresponds
        !  to s^(n-i+1).  Its j-th element has power (n-i+1 - 2j).
        !  Replace the zero row with dP_aux/ds coefficients:
        !    new R(i,j) = (n-i+1 - 2j) * R(i-1, j)
        do j = 0, ncols-1
          R(i, j) = real(n - i + 1 - 2*j, 8) * R(i-1, j)
        end do
      end if

    end do

    ! ---- Count sign changes in first column -------------------------
    sign_changes = 0
    prev_sign    = 0.0d0
    do i = 0, nrows-1
      if (abs(R(i, 0)) > EPS) then
        cur_sign = sign(1.0d0, R(i, 0))
        if (prev_sign /= 0.0d0 .and. cur_sign /= prev_sign) &
          sign_changes = sign_changes + 1
        prev_sign = cur_sign
      end if
    end do

    ! ---- Print results ----------------------------------------------
    write(*,'(A)') repeat('=', 70)
    write(*,'("Polynomial: ",A)') trim(poly_name)
    write(*,'(A)') repeat('-', 70)
    write(*,'("Routh Array:")')
    write(*,*)

    do i = 0, nrows-1
      write(*,'("  s^",I2," | ")', advance='no') n - i
      do j = 0, ncols-1
        write(*,'(F13.5)', advance='no') R(i, j)
      end do
      if (i < nrows-1 .and. all(abs(R(i+1,:)) < EPS) .and. i+1 < nrows-1) then
        !  Warn that next row (before replacement) was zero
        write(*,'("    <- next row was all-zero (auxiliary poly used)")', advance='no')
      end if
      write(*,*)
    end do

    write(*,*)
    write(*,'("  First column: ")', advance='no')
    do i = 0, nrows-1
      write(*,'(F10.4)', advance='no') R(i, 0)
    end do
    write(*,*)
    write(*,'("  Sign changes in first column: ",I0)') sign_changes
    write(*,*)

    !  Verdict
    if (sign_changes > 0) then
      write(*,'("  VERDICT: UNSTABLE")')
      write(*,'("    -> ",I0," sign change(s) in first column")') sign_changes
      write(*,'("    -> ",I0," root(s) have positive real part (right half-plane)")') &
        sign_changes
    else if (marginal) then
      write(*,'("  VERDICT: MARGINALLY STABLE")')
      write(*,'("    -> An all-zero row was detected.")')
      write(*,'("    -> The auxiliary polynomial has roots on the imaginary axis.")')
      write(*,'("    -> System is at the boundary of stability (not asymptotically stable).")')
    else
      write(*,'("  VERDICT: STABLE")')
      write(*,'("    -> No sign changes; all roots lie in the left half-plane.")')
    end if

    write(*,*)
    deallocate(R)

  end subroutine analyze

end program routh_hurwitz

