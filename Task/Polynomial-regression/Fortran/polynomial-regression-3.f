! ==============================================================================
! ===========================================================================
! poly_fit.f90
!
! Fits an approximating polynomial of user-specified degree to a set of
! (x, y) data points using the method of least squares.
!
! Method overview
! ---------------
! Given n data points (x_i, y_i) and a desired degree d, we look for
! coefficients a(0), a(1), ..., a(d) such that
!
!     P(x) = a(0) + a(1)*x + a(2)*x^2 + ... + a(d)*x^d
!
! minimises the sum of squared residuals:
!
!     S = sum_{i=1}^{n}  [ y_i - P(x_i) ]^2
!
! Setting dS/da(k) = 0 for each k leads to the "normal equations":
!
!     (A^T A) coef = A^T y
!
! where A is the Vandermonde matrix  A(i,j) = x_i^(j-1),  shape (n x d+1).
! The symmetric positive-definite system is solved by Gaussian elimination
! with partial pivoting.
!
! Example data (degree-2 exact fit):
!   x = 0  1  2  3  4  5   6   7   8   9  10
!   y = 1  6 17 34 57 86 121 162 209 262 321
!   => P(x) = 3x^2 + 2x + 1
! ===========================================================================

program poly_fit
    implicit none

    ! dp: double-precision kind selector â€” portable across compilers
    integer, parameter :: dp   = kind(1.0d0)
    integer, parameter :: npts = 11          ! total number of data points

    ! ----- data arrays -----
    real(dp) :: xdata(npts)   ! independent variable values
    real(dp) :: ydata(npts)   ! dependent variable values (observations)

    ! ----- working arrays (allocated after degree is known) -----
    real(dp), allocatable :: Amat(:,:)  ! Vandermonde matrix,  shape (npts  x deg+1)
    real(dp), allocatable :: ATA(:,:)   ! A^T * A,             shape (deg+1 x deg+1)
    real(dp), allocatable :: ATy(:)     ! A^T * y,             length deg+1
    real(dp), allocatable :: coef(:)    ! polynomial coefficients a(0)..a(deg)

    real(dp) :: y_fit   ! fitted value at one point
    real(dp) :: err     ! residual at one point
    integer  :: deg     ! polynomial degree (entered by user)
    integer  :: i, j    ! loop indices

    ! -----------------------------------------------------------------------
    ! Input data
    ! -----------------------------------------------------------------------
    xdata = [0d0, 1d0, 2d0, 3d0, 4d0, 5d0, 6d0, 7d0, 8d0, 9d0, 10d0]
    ydata = [1d0, 6d0, 17d0, 34d0, 57d0, 86d0, 121d0, 162d0, 209d0, 262d0, 321d0]

    ! -----------------------------------------------------------------------
    ! Read desired polynomial degree from the user
    ! -----------------------------------------------------------------------
    write(*,'(A)', advance='no') 'Enter polynomial degree: '
    read(*,*) deg

    ! -----------------------------------------------------------------------
    ! Allocate arrays now that deg is known
    !   Amat : n rows  (one per data point),  deg+1 columns (one per power)
    !   ATA  : (deg+1) x (deg+1) symmetric matrix from A^T*A
    !   ATy  : (deg+1) right-hand-side vector from A^T*y
    !   coef : (deg+1) solution vector â€” the polynomial coefficients
    ! -----------------------------------------------------------------------
    allocate(Amat(npts, deg+1), ATA(deg+1, deg+1), ATy(deg+1), coef(deg+1))

    ! -----------------------------------------------------------------------
    ! Build the Vandermonde matrix
    !
    !   Amat(i, j+1) = x_i ^ j,   i = 1..npts,  j = 0..deg
    !
    !   Row i corresponds to data point x_i.
    !   Column j+1 holds the j-th power of x, so the columns are:
    !       [ 1,  x,  x^2,  x^3, ... ]
    ! -----------------------------------------------------------------------
    do i = 1, npts
        do j = 0, deg
            Amat(i, j+1) = xdata(i)**j
        end do
    end do

    ! -----------------------------------------------------------------------
    ! Form the normal equations
    !
    !   ATA(i,j) = sum_k  Amat(k,i) * Amat(k,j)   =  (A^T A)(i,j)
    !   ATy(i)   = sum_k  Amat(k,i) * ydata(k)     =  (A^T y)(i)
    !
    ! Fortran's intrinsic sum() operates element-wise on full columns,
    ! so  sum(Amat(:,i) * Amat(:,j))  is the dot product of columns i and j.
    ! -----------------------------------------------------------------------
    do i = 1, deg+1
        ATy(i) = sum(Amat(:,i) * ydata)        ! i-th element of A^T y
        do j = 1, deg+1
            ATA(i,j) = sum(Amat(:,i) * Amat(:,j))  ! (i,j) element of A^T A
        end do
    end do

    ! -----------------------------------------------------------------------
    ! Solve the (deg+1) x (deg+1) linear system  ATA * coef = ATy
    ! using Gaussian elimination with partial pivoting (see subroutine below).
    ! On return, coef(k+1) holds the coefficient a(k) of x^k.
    ! -----------------------------------------------------------------------
    call gauss(ATA, ATy, coef, deg+1)

    ! -----------------------------------------------------------------------
    ! Print the fitted coefficients
    ! -----------------------------------------------------------------------
    write(*,*)
    write(*,*) 'Fitted polynomial coefficients:'
    do i = 0, deg
        ! coef(i+1) = a(i)  because Fortran arrays are 1-indexed
        write(*,'(4X,"a(",I0,") = ",F18.10)') i, coef(i+1)
    end do

    ! -----------------------------------------------------------------------
    ! Verification table: compare actual y vs. polynomial-evaluated y
    ! -----------------------------------------------------------------------
    write(*,*)
    write(*,'(4(A14))') 'x', 'y_actual', 'y_fitted', 'residual'
    write(*,'(56("-"))')

    do i = 1, npts
        ! Evaluate P(x_i) = sum_{j=0}^{deg}  coef(j+1) * x_i^j
        y_fit = 0d0
        do j = 0, deg
            y_fit = y_fit + coef(j+1) * xdata(i)**j
        end do

        err = ydata(i) - y_fit   ! residual: zero for an exact fit

        ! ES format (scientific notation) for residual highlights rounding errors
        write(*,'(F14.4, F14.4, F14.6, ES14.4)') xdata(i), ydata(i), y_fit, err
    end do

    ! -----------------------------------------------------------------------
    ! Free heap memory (good practice; Fortran also frees on program exit)
    ! -----------------------------------------------------------------------
    deallocate(Amat, ATA, ATy, coef)

! ===========================================================================
contains
! ===========================================================================

    ! -----------------------------------------------------------------------
    ! subroutine gauss(Mat, rhs, sol, sz)
    !
    ! Solves the sz x sz linear system  Mat * sol = rhs  by Gaussian
    ! elimination with partial pivoting (row swaps).
    !
    ! Arguments:
    !   Mat  (inout) : coefficient matrix; overwritten during elimination
    !   rhs  (inout) : right-hand side vector; overwritten during elimination
    !   sol  (out)   : solution vector
    !   sz   (in)    : system size
    !
    ! Partial pivoting: at each elimination step k, the row with the largest
    ! absolute value in column k (at or below the diagonal) is swapped to the
    ! pivot row.  This keeps multipliers |fac| <= 1, greatly reducing the
    ! growth of rounding errors compared to naive elimination.
    ! -----------------------------------------------------------------------
    subroutine gauss(Mat, rhs, sol, sz)
        integer,  intent(in)    :: sz
        real(dp), intent(inout) :: Mat(sz,sz)  ! system matrix (modified in place)
        real(dp), intent(inout) :: rhs(sz)     ! right-hand side (modified in place)
        real(dp), intent(out)   :: sol(sz)     ! solution vector

        integer  :: i, j, k   ! loop indices
        integer  :: piv        ! row index of the current pivot
        real(dp) :: fac        ! elimination multiplier  Mat(i,k) / Mat(k,k)
        real(dp) :: mx         ! largest absolute value found in pivot search
        real(dp) :: tmp        ! scratch variable for row swaps

        ! -------------------------------------------------------------------
        ! Forward elimination â€” reduce Mat to upper-triangular form
        ! -------------------------------------------------------------------
        do k = 1, sz-1     ! process each column k left to right

            ! --- locate the pivot: row with largest |Mat(i,k)| in col k ---
            mx = abs(Mat(k,k))
            piv = k
            do i = k+1, sz
                if (abs(Mat(i,k)) > mx) then
                    mx  = abs(Mat(i,k))
                    piv = i
                end if
            end do

            ! --- swap pivot row into position k (if needed) ---
            if (piv /= k) then
                do j = 1, sz
                    tmp = Mat(k,j);  Mat(k,j) = Mat(piv,j);  Mat(piv,j) = tmp
                end do
                tmp = rhs(k);  rhs(k) = rhs(piv);  rhs(piv) = tmp
            end if

            ! --- eliminate entries below the diagonal in column k ---
            do i = k+1, sz
                fac = Mat(i,k) / Mat(k,k)          ! multiplier for row i

                ! subtract fac * row_k from row_i (array section for speed)
                Mat(i, k:sz) = Mat(i, k:sz) - fac * Mat(k, k:sz)

                ! apply the same operation to the right-hand side
                rhs(i) = rhs(i) - fac * rhs(k)
            end do

        end do  ! end forward elimination

        ! -------------------------------------------------------------------
        ! Back substitution â€” solve upper-triangular system for sol
        !
        !   sol(sz) = rhs(sz) / Mat(sz,sz)
        !   sol(i)  = ( rhs(i) - sum_{j=i+1}^{sz} Mat(i,j)*sol(j) ) / Mat(i,i)
        ! -------------------------------------------------------------------
        sol(sz) = rhs(sz) / Mat(sz,sz)   ! bottom equation: one unknown

        do i = sz-1, 1, -1              ! work upward from second-to-last row
            ! subtract the already-known part and divide by the diagonal
            sol(i) = ( rhs(i) - sum(Mat(i, i+1:sz) * sol(i+1:sz)) ) / Mat(i,i)
        end do

    end subroutine gauss

end program poly_fit

