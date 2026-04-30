!===========================================================
! Program: rdp_demo
! Purpose: Demonstrate the Ramer–Douglas–Peucker (RDP) algorithm
!          for polyline simplification. The algorithm reduces
!          the number of points in a curve while preserving
!          its overall shape within a tolerance.
!===========================================================
program rdp_demo
  implicit none

  !----------------------------------------------------------
  ! Define constants and parameters
  !----------------------------------------------------------
  integer, parameter :: dp = kind(1.0d0)   ! Double precision kind
  integer, parameter :: n  = 10            ! Number of input points

  !----------------------------------------------------------
  ! Declare arrays
  !----------------------------------------------------------
  real(dp), dimension(2,n) :: p            ! 2D points: p(1,i)=x, p(2,i)=y
  logical,  dimension(n)   :: keep         ! Flags to mark points to keep
  integer :: i                             ! Loop index

  !----------------------------------------------------------
  ! Input polyline points (hardcoded for demo)
  ! Each column of p is a point (x,y).
  !----------------------------------------------------------
  p(:,1)  = (/0.0_dp, 0.0_dp/)
  p(:,2)  = (/1.0_dp, 0.1_dp/)
  p(:,3)  = (/2.0_dp,-0.1_dp/)
  p(:,4)  = (/3.0_dp, 5.0_dp/)
  p(:,5)  = (/4.0_dp, 6.0_dp/)
  p(:,6)  = (/5.0_dp, 7.0_dp/)
  p(:,7)  = (/6.0_dp, 8.1_dp/)
  p(:,8)  = (/7.0_dp, 9.0_dp/)
  p(:,9)  = (/8.0_dp, 9.0_dp/)
  p(:,10) = (/9.0_dp, 9.0_dp/)

  !----------------------------------------------------------
  ! Initialize keep array: all points initially marked false
  !----------------------------------------------------------
  keep = .false.

  !----------------------------------------------------------
  ! Call RDP algorithm:
  ! Arguments:
  !   p     = array of points
  !   1     = starting index
  !   n     = ending index
  !   1.0_dp= tolerance epsilon (max allowed deviation)
  !   keep  = logical array to mark retained points
  !----------------------------------------------------------
  call rdp(p, 1, n, 1.0_dp, keep)

  !----------------------------------------------------------
  ! Print the remaining points after simplification
  !----------------------------------------------------------
  print *, "Remaining points:"
  do i = 1, n
     if (keep(i)) then
        ! Print coordinates with fixed format (10-wide, 3 decimals)
        print '(2f10.3)', p(1,i), p(2,i)
     end if
  end do

contains

  !===========================================================
  ! Subroutine: rdp
  ! Purpose   : Recursive implementation of Ramer–Douglas–Peucker
  !             algorithm. Decides which points to keep.
  !===========================================================
  subroutine rdp(pts, i1, i2, eps, keep)
    real(dp), intent(in)  :: pts(:,:)     ! Input array of points
    integer, intent(in)   :: i1, i2        ! Start and end indices
    real(dp), intent(in)  :: eps           ! Tolerance epsilon
    logical, intent(inout):: keep(:)       ! Array marking kept points
    integer :: i, idx_max                  ! Loop index, index of max deviation
    real(dp) :: dmax, d                    ! Max distance, current distance

    ! Initialize maximum distance and index
    dmax    = 0.0_dp
    idx_max = -1

    !----------------------------------------------------------
    ! Loop through intermediate points between i1 and i2
    ! Find the point farthest from the line segment (i1,i2).
    !----------------------------------------------------------
    do i = i1+1, i2-1
       d = perp_dist(pts(:,i), pts(:,i1), pts(:,i2))
       if (d > dmax) then
          dmax    = d
          idx_max = i
       end if
    end do

    !----------------------------------------------------------
    ! Decision:
    ! If the maximum distance exceeds epsilon, split and recurse.
    ! Otherwise, mark endpoints as kept.
    !----------------------------------------------------------
    if (dmax > eps .and. idx_max /= -1) then
       ! Recurse on left segment (i1 to idx_max)
       call rdp(pts, i1, idx_max, eps, keep)
       ! Recurse on right segment (idx_max to i2)
       call rdp(pts, idx_max, i2, eps, keep)
    else
       ! Endpoints are significant, mark them as kept
       keep(i1) = .true.
       keep(i2) = .true.
    end if
  end subroutine rdp

  !===========================================================
  ! Function: perp_dist
  ! Purpose : Compute perpendicular distance from point p to
  !           line segment defined by points a and b.
  !===========================================================
  function perp_dist(p, a, b) result(d)
    real(dp), intent(in) :: p(2), a(2), b(2) ! Input points
    real(dp) :: d                            ! Resulting distance
    real(dp) :: vx, vy, wx, wy               ! Vector components
    real(dp) :: num, den                     ! Numerator, denominator

    ! Vector v = b - a (line segment direction)
    vx = b(1) - a(1)
    vy = b(2) - a(2)

    ! Vector w = p - a (point relative to a)
    wx = p(1) - a(1)
    wy = p(2) - a(2)

    ! Cross product magnitude |v x w| gives area of parallelogram
    num = abs(vx*wy - vy*wx)

    ! Length of vector v (denominator for distance formula)
    den = sqrt(vx*vx + vy*vy)

    ! Distance = area / base length
    if (den > 0.0_dp) then
       d = num / den
    else
       ! Degenerate case: a and b are the same point
       d = 0.0_dp
    end if
  end function perp_dist

end program rdp_demo
