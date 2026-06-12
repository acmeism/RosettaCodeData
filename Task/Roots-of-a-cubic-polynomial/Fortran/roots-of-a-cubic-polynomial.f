! =============================================================================
! roots.f90  --  Eigenvalues of real 3x3 matrices via the characteristic
!                polynomial (a cubic).  Six test matrices are solved and
!                forward errors are estimated.
!
! Algorithm:
!   1. char_poly:      build  det(lambda*I-A) = lambda^3+b*lambda^2+c*lambda+d
!   2. solve_cubic:    remove x^2 term (Tschirnhaus substitution x=t-Bn/3)
!   3. solve_depressed: branch on discriminant  Delta = -4p^3 - 27q^2
!        Delta > 0  =>  three distinct real roots  (trigonometric method)
!        Delta ~ 0  =>  repeated roots             (closed-form formulas)
!        Delta < 0  =>  one real + two complex     (Cardano's formula)
!   4. Error estimate: bk = |p(root)|/||coefs||_inf;  fwd = bk^(1/mult)
! =============================================================================
program roots
  use iso_fortran_env, only: real64
  implicit none

  real(kind=real64)    :: mat(3,3)      ! current test matrix
  real(kind=real64)    :: ca,cb,cc,cd   ! characteristic polynomial coefficients
  complex(kind=real64) :: evals(3)      ! eigenvalues (may be complex)
  real(kind=real64)    :: errs(3)       ! forward error estimates (real magnitudes)
  logical              :: is_cmplx(3)   ! .true. when eigenvalue is not purely real
  integer              :: itest, i
  real(kind=real64)    :: pi

  pi = acos(-1.0_real64)

  do itest = 1, 6

    ! ===================================================================
    ! Load the test matrix for this iteration.
    ! ===================================================================
    select case(itest)

    case(1)
      ! Upper triangular; triple eigenvalue 1.
      ! Char. poly.: x^3 - 3x^2 + 3x - 1
      mat(1,:) = [ 1.0_real64, -1.0_real64,  0.0_real64]
      mat(2,:) = [ 0.0_real64,  1.0_real64,  1.0_real64]
      mat(3,:) = [ 0.0_real64,  0.0_real64,  1.0_real64]

    case(2)
      ! Three distinct real eigenvalues: 3, 6, -5.
      ! Char. poly.: x^3 - 4x^2 - 27x + 90
      mat(1,:) = [-2.0_real64, -4.0_real64,  2.0_real64]
      mat(2,:) = [-2.0_real64,  1.0_real64,  2.0_real64]
      mat(3,:) = [ 4.0_real64,  2.0_real64,  5.0_real64]

    case(3)
      ! Wikipedia example: upper triangular, triple eigenvalue 1.
      ! Char. poly.: x^3 - 3x^2 + 3x - 1
      mat(1,:) = [ 1.0_real64, -1.0_real64,  0.0_real64]
      mat(2,:) = [ 0.0_real64,  1.0_real64, -1.0_real64]
      mat(3,:) = [ 0.0_real64,  0.0_real64,  1.0_real64]

    case(4)
      ! Diagonal; eigenvalues 2, -1, -1  (one double root).
      ! Char. poly.: x^3 - 3x - 2
      mat(1,:) = [ 2.0_real64,  0.0_real64,  0.0_real64]
      mat(2,:) = [ 0.0_real64, -1.0_real64,  0.0_real64]
      mat(3,:) = [ 0.0_real64,  0.0_real64, -1.0_real64]

    case(5)
      ! Block-diagonal 1x1 + 2x2; eigenvalues 2, 1, 11.
      ! The 2x2 block [[3,4],[4,9]] has eigenvalues 1 and 11.
      ! Char. poly.: x^3 - 14x^2 + 35x - 22
      mat(1,:) = [ 2.0_real64,  0.0_real64,  0.0_real64]
      mat(2,:) = [ 0.0_real64,  3.0_real64,  4.0_real64]
      mat(3,:) = [ 0.0_real64,  4.0_real64,  9.0_real64]

    case(6)
      ! 1x1 identity block + 2x2 rotation by pi/4 (45 degrees).
      ! Eigenvalues: 1 (real),  e^(+i*pi/4),  e^(-i*pi/4)  (complex pair).
      mat(1,:) = [ 1.0_real64,  0.0_real64,           0.0_real64          ]
      mat(2,:) = [ 0.0_real64,  cos(pi/4.0_real64),  -sin(pi/4.0_real64) ]
      mat(3,:) = [ 0.0_real64,  sin(pi/4.0_real64),   cos(pi/4.0_real64) ]

    end select

    ! ===================================================================
    write(*,'(A,I0,A)') 'For matrix ', itest, ':'
    call print_matrix(mat)
    write(*,*)

    call char_poly(mat, ca, cb, cc, cd)
    write(*,'(A)') 'whose characteristic polynomial is:'
    call print_poly(ca, cb, cc, cd)
    write(*,*)

    call solve_cubic(ca, cb, cc, cd, evals, errs, is_cmplx)

    write(*,'(A)', advance='no') 'Its eigenValues are: ['
    do i = 1, 3
      if (i > 1) write(*,'(A)', advance='no') ',  '
      call print_eval(evals(i), is_cmplx(i))
    end do
    write(*,'(A)') ']'

    write(*,'(A)', advance='no') 'and the corresponding errors are: ['
    do i = 1, 3
      if (i > 1) write(*,'(A)', advance='no') ', '
      call print_error(errs(i), is_cmplx(i))
    end do
    write(*,'(A)') ']'

    write(*,*)
    write(*,'(A)') repeat('-', 60)
    write(*,*)

  end do

contains

  ! ====================================================================
  ! trim_number -- format a real value as a compact string.
  ! If the value is within rounding distance of an integer, display as
  ! integer (no decimal point).  Otherwise use fixed decimal notation
  ! with trailing zeros stripped.
  ! ====================================================================
  function trim_number(x) result(s)
    real(kind=real64), intent(in) :: x
    character(len=40) :: s
    character(len=40) :: tmp
    integer :: n, ix

    ix = nint(x)
    if (abs(x - real(ix, real64)) < 1.0e-9_real64 * (abs(x) + 1.0_real64)) then
      write(s, '(I0)') ix
    else
      ! Fixed decimal with 14 places, then strip trailing zeros and lone dot
      write(tmp, '(F30.14)') x
      s = adjustl(tmp)
      n = len_trim(s)
      do while (n > 1 .and. s(n:n) == '0')
        s(n:n) = ' '
        n = n - 1
      end do
      if (n >= 1 .and. s(n:n) == '.') s(n:n) = ' '
      s = adjustl(s)
    end if
  end function trim_number

  ! ====================================================================
  ! print_matrix -- display a 3x3 matrix with vertical bars.
  ! Integer-valued matrices use integer format; others use F18.14.
  ! ====================================================================
  subroutine print_matrix(m)
    real(kind=real64), intent(in) :: m(3,3)
    integer :: i, j
    logical :: all_int

    ! Check whether every element rounds to an integer
    all_int = .true.
    do i = 1, 3
      do j = 1, 3
        if (abs(m(i,j) - real(nint(m(i,j)), real64)) > &
            1.0e-9_real64 * (abs(m(i,j)) + 1.0_real64)) all_int = .false.
      end do
    end do

    do i = 1, 3
      if (all_int) then
        write(*,'(A,3I4,A)') '|', nint(m(i,:)), ' |'
      else
        write(*,'(A,3F18.14,A)') '|', m(i,:), ' |'
      end if
    end do
  end subroutine print_matrix

  ! ====================================================================
  ! print_poly -- display  a*x^3 + b*x^2 + c*x + d
  ! with explicit sign between terms; zero terms are omitted.
  ! ====================================================================
  subroutine print_poly(a, b, c, d)
    real(kind=real64), intent(in) :: a, b, c, d
    logical :: first
    first = .true.
    call write_term(a, 'x^3', first)
    call write_term(b, 'x^2', first)
    call write_term(c, 'x',   first)
    call write_term(d, '',    first)
    write(*,*)
  end subroutine print_poly

  ! Helper: append one term of the polynomial to stdout.
  ! 'first' is .true. for the leading term (no sign prefix printed).
  ! Coefficient '1' is suppressed when a variable part is present.
  subroutine write_term(coef, varpart, first)
    real(kind=real64), intent(in)    :: coef
    character(len=*),  intent(in)    :: varpart
    logical,           intent(inout) :: first
    character(len=40) :: ns
    real(kind=real64) :: acoef

    if (abs(coef) < 1.0e-12_real64) return   ! skip zero terms

    acoef = abs(coef)
    ns    = trim_number(acoef)

    if (first) then
      if (coef < 0.0_real64) write(*,'(A)', advance='no') '-'
      ! Suppress '1' before a variable (e.g. x^3 not 1x^3); keep for constants
      if (abs(acoef - 1.0_real64) > 1.0e-12_real64 .or. len_trim(varpart) == 0) &
        write(*,'(A)', advance='no') trim(ns)
      write(*,'(A)', advance='no') trim(varpart)
      first = .false.
    else
      if (coef > 0.0_real64) then
        write(*,'(A)', advance='no') ' +'
      else
        write(*,'(A)', advance='no') ' -'
      end if
      if (abs(acoef - 1.0_real64) > 1.0e-12_real64 .or. len_trim(varpart) == 0) &
        write(*,'(A)', advance='no') trim(ns)
      write(*,'(A)', advance='no') trim(varpart)
    end if
  end subroutine write_term

  ! ====================================================================
  ! print_eval -- display one eigenvalue.
  ! Real eigenvalues: just the number.
  ! Complex eigenvalues: real_part +/- imag_part i
  ! ====================================================================
  subroutine print_eval(z, is_c)
    complex(kind=real64), intent(in) :: z
    logical,              intent(in) :: is_c
    character(len=40) :: re_s, im_s
    real(kind=real64) :: re, im

    re   = real(z, kind=real64)
    im   = aimag(z)
    re_s = trim_number(re)

    if (.not. is_c) then
      write(*,'(A)', advance='no') trim(re_s)
    else
      im_s = trim_number(abs(im))
      if (im >= 0.0_real64) then
        write(*,'(A)', advance='no') trim(re_s)//' + '//trim(im_s)//'i'
      else
        write(*,'(A)', advance='no') trim(re_s)//' - '//trim(im_s)//'i'
      end if
    end if
  end subroutine print_eval

  ! ====================================================================
  ! print_error -- display one error estimate.
  ! For complex eigenvalues the error is a real magnitude shown in the
  ! same complex notation as the eigenvalue (imaginary part is 0).
  ! ====================================================================
  subroutine print_error(err, is_c)
    real(kind=real64), intent(in) :: err
    logical,           intent(in) :: is_c
    character(len=40) :: es
    es = trim_number(err)
    if (.not. is_c) then
      write(*,'(A)', advance='no') trim(es)
    else
      write(*,'(A)', advance='no') trim(es)//' + 0i'
    end if
  end subroutine print_error

  ! ====================================================================
  ! char_poly -- build the characteristic polynomial of a 3x3 matrix.
  !
  ! det(lambda*I - A) = lambda^3 + b*lambda^2 + c*lambda + d  where:
  !   a = 1            (monic; returned for interface completeness)
  !   b = -trace(A)
  !   c = M_11+M_22+M_33  (sum of 2x2 principal minors of A)
  !   d = -det(A)
  !
  ! Principal minor M_ii is the determinant of A with row i and
  ! column i deleted.
  ! ====================================================================
  subroutine char_poly(mat, a, b, c, d)
    real(kind=real64), intent(in)  :: mat(3,3)
    real(kind=real64), intent(out) :: a, b, c, d
    real(kind=real64) :: tr, m2sum, detA

    a = 1.0_real64

    ! b = -trace
    tr = mat(1,1) + mat(2,2) + mat(3,3)
    b  = -tr

    ! c = sum of 2x2 principal minors
    ! M_33 = det A rows{1,2} cols{1,2}
    ! M_22 = det A rows{1,3} cols{1,3}
    ! M_11 = det A rows{2,3} cols{2,3}
    m2sum = (mat(1,1)*mat(2,2) - mat(1,2)*mat(2,1)) &
          + (mat(1,1)*mat(3,3) - mat(1,3)*mat(3,1)) &
          + (mat(2,2)*mat(3,3) - mat(2,3)*mat(3,2))
    c = m2sum

    ! d = -det(A); cofactor expansion along row 1
    detA = mat(1,1)*(mat(2,2)*mat(3,3) - mat(2,3)*mat(3,2)) &
         - mat(1,2)*(mat(2,1)*mat(3,3) - mat(2,3)*mat(3,1)) &
         + mat(1,3)*(mat(2,1)*mat(3,2) - mat(2,2)*mat(3,1))
    d = -detA
  end subroutine char_poly

  ! ====================================================================
  ! solve_depressed -- roots of the monic depressed cubic  t^3+p*t+q=0.
  !
  ! The discriminant  Delta = -4p^3 - 27q^2  determines the case:
  !
  !  Delta > 0  Three distinct real roots.  Trigonometric (Vieta) method:
  !               m     = 2*sqrt(-p/3)
  !               theta = (1/3)*arccos(3q/(p*m))
  !               t_k   = m*cos(theta - 2*pi*(k-1)/3),  k=1,2,3
  !             This avoids complex arithmetic and is stable for all three
  !             real roots because -p/3 > 0 and the arccos argument is in
  !             [-1,1] whenever Delta > 0.
  !
  !  Delta ~ 0  Repeated roots.
  !             If p=q=0: triple root t=0  (polynomial is t^3=0).
  !             Otherwise: double root at 3q/p, simple root at -6q/p.
  !
  !  Delta < 0  One real root + two complex conjugates (Cardano):
  !               D3 = -Delta/108 = (q/2)^2 + (p/3)^3  (positive here)
  !               u  = cbrt(-q/2 + sqrt(D3))
  !               v  = cbrt(-q/2 - sqrt(D3))    with  u*v = -p/3
  !               Real root:     t1 = u + v
  !               Complex pair:  t2 = -(u+v)/2 + i*(u-v)*sqrt(3)/2
  !                              t3 = -(u+v)/2 - i*(u-v)*sqrt(3)/2
  !             sign()*abs()^(1/3) avoids a domain error for negative bases.
  !
  ! All roots are returned as complex(real64); is_cmplx flags which have
  ! a nonzero imaginary part.
  ! ====================================================================
  subroutine solve_depressed(p, q, roots, is_cmplx)
    real(kind=real64),    intent(in)  :: p, q
    complex(kind=real64), intent(out) :: roots(3)
    logical,              intent(out) :: is_cmplx(3)
    real(kind=real64) :: pi, Delta, m, theta, u, v, D3, sq3
    integer :: k

    pi    = acos(-1.0_real64)
    sq3   = sqrt(3.0_real64)
    Delta = -4.0_real64*p**3 - 27.0_real64*q**2

    ! ------------------------------------------------------------------
    ! Three distinct real roots -- trigonometric method
    ! ------------------------------------------------------------------
    if (Delta > 0.0_real64) then

      m     = 2.0_real64 * sqrt(-p / 3.0_real64)
      theta = (1.0_real64/3.0_real64) * acos(3.0_real64*q / (p*m))
      do k = 1, 3
        roots(k) = cmplx(m * cos(theta - 2.0_real64*pi*real(k-1,real64)/3.0_real64), &
                         0.0_real64, kind=real64)
      end do
      is_cmplx = .false.

    ! ------------------------------------------------------------------
    ! Repeated roots (Delta numerically zero)
    ! Tolerance scaled by |p|^3+1 to work for both large and small p.
    ! ------------------------------------------------------------------
    else if (abs(Delta) <= 1.0e-10_real64 * (abs(p)**3 + 1.0_real64)) then

      if (abs(p) <= 1.0e-12_real64 .and. abs(q) <= 1.0e-12_real64) then
        ! t^3 = 0: triple root at the origin
        roots    = cmplx(0.0_real64, 0.0_real64, kind=real64)
      else
        ! Double root and simple root derived from Vieta's formulas at Delta=0
        roots(1) = cmplx( 3.0_real64*q/p, 0.0_real64, kind=real64)  ! double
        roots(2) = cmplx(-6.0_real64*q/p, 0.0_real64, kind=real64)  ! simple
        roots(3) = roots(1)
      end if
      is_cmplx = .false.

    ! ------------------------------------------------------------------
    ! One real root + two complex conjugates -- Cardano's formula
    ! ------------------------------------------------------------------
    else

      D3 = -Delta / 108.0_real64   ! equals (q/2)^2 + (p/3)^3, positive here

      ! Real cube roots using sign() to handle negative radicands safely
      u = sign(1.0_real64, -q/2.0_real64 + sqrt(D3)) &
        * abs(-q/2.0_real64 + sqrt(D3))**(1.0_real64/3.0_real64)
      v = sign(1.0_real64, -q/2.0_real64 - sqrt(D3)) &
        * abs(-q/2.0_real64 - sqrt(D3))**(1.0_real64/3.0_real64)

      roots(1) = cmplx(u + v,             0.0_real64,          kind=real64)
      roots(2) = cmplx(-(u+v)/2.0_real64,  (u-v)*sq3/2.0_real64, kind=real64)
      roots(3) = cmplx(-(u+v)/2.0_real64, -(u-v)*sq3/2.0_real64, kind=real64)

      is_cmplx(1) = .false.
      is_cmplx(2) = .true.
      is_cmplx(3) = .true.

    end if
  end subroutine solve_depressed

  ! ====================================================================
  ! solve_cubic -- solve  a*x^3 + b*x^2 + c*x + d = 0  and estimate
  !               forward errors for each root.
  !
  ! Reduction steps:
  !   1. Divide by a  =>  monic  x^3 + Bn*x^2 + Cn*x + Dn = 0
  !   2. Substitute  x = t - Bn/3  (removes x^2 term):
  !        p = Cn - Bn^2/3
  !        q = Dn - Bn*Cn/3 + 2*Bn^3/27
  !   3. Call solve_depressed for t; shift back: x = t - Bn/3.
  !
  ! Error estimation:
  !   Backward error  bk = |p(root)| / ||coefs||_inf  evaluated in
  !   complex arithmetic via Horner's method.
  !   Forward error   fwd = bk^(1/mult)  where mult is the root's
  !   algebraic multiplicity.  Complex roots of a real polynomial are
  !   always simple (mult=1).  For real roots, multiplicity is inferred
  !   from |p'(root)|: small derivative => likely triple root (mult=3).
  ! ====================================================================
  subroutine solve_cubic(a, b, c, d, xroots, errs, is_cmplx)
    real(kind=real64),    intent(in)  :: a, b, c, d
    complex(kind=real64), intent(out) :: xroots(3)
    real(kind=real64),    intent(out) :: errs(3)
    logical,              intent(out) :: is_cmplx(3)

    real(kind=real64)    :: Bn, Cn, Dn, shift, tp, tq, poly_norm, bk_err
    complex(kind=real64) :: troots(3), pval, dpval
    integer :: i, mult

    ! Normalize to monic
    Bn = b / a
    Cn = c / a
    Dn = d / a

    ! Tschirnhaus-Vieta: x = t - Bn/3 eliminates the x^2 term.
    ! Substituting and expanding gives p and q for  t^3 + p*t + q = 0.
    shift = Bn / 3.0_real64
    tp    = Cn - Bn*Bn/3.0_real64
    tq    = Dn - Bn*Cn/3.0_real64 + 2.0_real64*Bn**3/27.0_real64

    call solve_depressed(tp, tq, troots, is_cmplx)

    ! Shift roots back to the original variable
    do i = 1, 3
      xroots(i) = troots(i) - cmplx(shift, 0.0_real64, kind=real64)
    end do

    ! ------------------------------------------------------------------
    ! Error estimation for each root
    ! ------------------------------------------------------------------
    poly_norm = max(abs(a), abs(b), abs(c), abs(d))

    do i = 1, 3

      ! Polynomial evaluated at xroots(i) using Horner's method.
      ! Horner: p(x) = ((a*x + b)*x + c)*x + d  -- minimises rounding.
      pval = cmplx(a, 0.0_real64, kind=real64)
      pval = pval * xroots(i) + cmplx(b, 0.0_real64, kind=real64)
      pval = pval * xroots(i) + cmplx(c, 0.0_real64, kind=real64)
      pval = pval * xroots(i) + cmplx(d, 0.0_real64, kind=real64)

      bk_err = abs(pval) / poly_norm   ! dimensionless backward error

      ! Derivative p'(x) = 3ax^2 + 2bx + c at the computed root.
      ! Small |p'| indicates a repeated root (condition number blows up).
      dpval = cmplx(3.0_real64*a, 0.0_real64, kind=real64) * xroots(i)**2 &
            + cmplx(2.0_real64*b, 0.0_real64, kind=real64) * xroots(i)    &
            + cmplx(c, 0.0_real64, kind=real64)

      if (is_cmplx(i)) then
        mult = 1         ! complex roots of real polynomials are always simple
      else if (abs(dpval) > 1.0e-6_real64) then
        mult = 1         ! simple real root
      else
        mult = 3         ! derivative near zero: assume triple root (worst case)
      end if

      ! Forward error scales as bk^(1/mult):
      !   simple root (mult=1): linear sensitivity
      !   triple root (mult=3): cube-root sensitivity (much worse conditioning)
      if (bk_err <= 0.0_real64) then
        errs(i) = 0.0_real64
      else
        errs(i) = bk_err**(1.0_real64 / real(mult, real64))
      end if

    end do
  end subroutine solve_cubic

end program roots

