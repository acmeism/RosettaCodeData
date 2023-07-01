module convex_hulls
  !
  ! Convex hulls by Andrew's monotone chain algorithm.
  !
  ! For a description of the algorithm, see
  ! https://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain&stableid=40169
  !
  ! For brevity in the task, I shall use the built-in "complex" type
  ! to represent objects in the plane. One could have fun rewriting
  ! this implementation in terms of geometric algebra.
  !

  implicit none
  private

  public :: find_convex_hull

contains

  elemental function x (u)
    complex, intent(in) :: u
    real :: x

    x = real (u)
  end function x

  elemental function y (u)
    complex, intent(in) :: u
    real :: y

    y = aimag (u)
  end function y

  elemental function cross (u, v) result (p)
    complex, intent(in) :: u, v
    real :: p

    ! The cross product as a signed scalar.
    p = (x (u) * y (v)) - (y (u) * x (v))
  end function cross

  subroutine sort_points (num_points, points)
    integer, intent(in) :: num_points
    complex, intent(inout) :: points(0:*)

    ! Sort first in ascending order by x-coordinates, then in
    ! ascending order by y-coordinates. Any decent sort algorithm will
    ! suffice; for the sake of interest, here is the Shell sort of
    ! https://en.wikipedia.org/w/index.php?title=Shellsort&oldid=1084744510

    integer, parameter :: gaps(1:8) = (/ 701, 301, 132, 57, 23, 10, 4, 1 /)

    integer :: i, j, k, gap, offset
    complex :: temp
    logical :: done

    do k = 1, 8
       gap = gaps(k)
       do offset = 0, gap - 1
          do i = offset, num_points - 1, gap
             temp = points(i)
             j = i
             done = .false.
             do while (.not. done)
                if (j < gap) then
                   done = .true.
                else if (x (points(j - gap)) < x (temp)) then
                   done = .true.
                else if (x (points(j - gap)) == x (temp) .and. &
                     &    (y (points(j - gap)) <= y (temp))) then
                   done = .true.
                else
                   points(j) = points(j - gap)
                   j = j - gap
                end if
             end do
             points(j) = temp
          end do
       end do
    end do
  end subroutine sort_points

  subroutine delete_neighbor_duplicates (n, pt)
    integer, intent(inout) :: n
    complex, intent(inout) :: pt(0:*)

    call delete_trailing_duplicates
    call delete_nontrailing_duplicates

  contains

    subroutine delete_trailing_duplicates
      integer :: i
      logical :: done

      i = n - 1
      done = .false.
      do while (.not. done)
         if (i == 0) then
            n = 1
            done = .true.
         else if (pt(i - 1) /= pt(i)) then
            n = i + 1
            done = .true.
         else
            i = i - 1
         end if
      end do
    end subroutine delete_trailing_duplicates

    subroutine delete_nontrailing_duplicates
      integer :: i, j, num_deleted
      logical :: done

      i = 0
      do while (i < n - 1)
         j = i + 1
         done = .false.
         do while (.not. done)
            if (j == n) then
               done = .true.
            else if (pt(j) /= pt(i)) then
               done = .true.
            else
               j = j + 1
            end if
         end do
         if (j /= i + 1) then
            num_deleted = j - i - 1
            do while (j /= n)
               pt(j - num_deleted) = pt(j)
               j = j + 1
            end do
            n = n - num_deleted
         end if
         i = i + 1
      end do
    end subroutine delete_nontrailing_duplicates

  end subroutine delete_neighbor_duplicates

  subroutine construct_lower_hull (n, pt, hull_size, hull)
    integer, intent(in) :: n    ! Number of points.
    complex, intent(in) :: pt(0:*)
    integer, intent(inout) :: hull_size
    complex, intent(inout) :: hull(0:*)

    integer :: i, j
    logical :: done

    j = 1
    hull(0:1) = pt(0:1)
    do i = 2, n - 1
       done = .false.
       do while (.not. done)
          if (j == 0) then
             j = j + 1
             hull(j) = pt(i)
             done = .true.
          else if (0.0 < cross (hull(j) - hull(j - 1), &
               &                pt(i) - hull(j - 1))) then
             j = j + 1
             hull(j) = pt(i)
             done = .true.
          else
             j = j - 1
          end if
       end do
    end do
    hull_size = j + 1
  end subroutine construct_lower_hull

  subroutine construct_upper_hull (n, pt, hull_size, hull)
    integer, intent(in) :: n    ! Number of points.
    complex, intent(in) :: pt(0:*)
    integer, intent(inout) :: hull_size
    complex, intent(inout) :: hull(0:*)

    integer :: i, j
    logical :: done

    j = 1
    hull(0:1) = pt(n - 1 : n - 2 : -1)
    do i = n - 3, 0, -1
       done = .false.
       do while (.not. done)
          if (j == 0) then
             j = j + 1
             hull(j) = pt(i)
             done = .true.
          else if (0.0 < cross (hull(j) - hull(j - 1), &
               &                pt(i) - hull(j - 1))) then
             j = j + 1
             hull(j) = pt(i)
             done = .true.
          else
             j = j - 1
          end if
       end do
    end do
    hull_size = j + 1
  end subroutine construct_upper_hull

  subroutine contruct_hull (n, pt, hull_size, hull)
    integer, intent(in) :: n    ! Number of points.
    complex, intent(in) :: pt(0:*)
    integer, intent(inout) :: hull_size
    complex, intent(inout) :: hull(0:*)

    integer :: lower_hull_size, upper_hull_size
    complex :: lower_hull(0 : n - 1), upper_hull(0 : n - 1)
    integer :: ihull0

    ihull0 = lbound (hull, 1)

    ! A side note: the calls to construct_lower_hull and
    ! construct_upper_hull could be done in parallel.
    call construct_lower_hull (n, pt, lower_hull_size, lower_hull)
    call construct_upper_hull (n, pt, upper_hull_size, upper_hull)

    hull_size = lower_hull_size + upper_hull_size - 2

    hull(:ihull0 + lower_hull_size - 2) =                          &
         & lower_hull(:lower_hull_size - 2)
    hull(ihull0 + lower_hull_size - 1 : ihull0 + hull_size - 1) =  &
         & upper_hull(0 : upper_hull_size - 2)
  end subroutine contruct_hull

  subroutine find_convex_hull (n, points, hull_size, hull)
    integer, intent(in) :: n            ! Number of points.
    complex, intent(in) :: points(*)    ! Input points.
    integer, intent(inout) :: hull_size ! The size of the hull.
    complex, intent(inout) :: hull(*)   ! Points of the hull.

    !
    ! Yes, you can call this with something like
    !
    !    call find_convex_hull (n, points, n, points)
    !
    ! and in the program below I shall demonstrate that.
    !

    complex :: pt(0 : n - 1)
    integer :: ipoints0, ihull0, numpt

    ipoints0 = lbound (points, 1)
    ihull0 = lbound (hull, 1)

    pt = points(:ipoints0 + n - 1)
    numpt = n

    call sort_points (numpt, pt)
    call delete_neighbor_duplicates (numpt, pt)

    if (numpt == 0) then
       hull_size = 0
    else if (numpt <= 2) then
       hull_size = numpt
       hull(:ihull0 + numpt - 1) = pt(:numpt - 1)
    else
       call contruct_hull (numpt, pt, hull_size, hull)
    end if
  end subroutine find_convex_hull

end module convex_hulls

program convex_hull_task
  use, non_intrinsic :: convex_hulls
  implicit none

  complex, parameter :: example_points(20) =                   &
       & (/ (16, 3), (12, 17), (0, 6), (-4, -6), (16, 6),      &
       &    (16, -7), (16, -3), (17, -4), (5, 19), (19, -8),   &
       &    (3, 16), (12, 13), (3, -4), (17, 5), (-3, 15),     &
       &    (-3, -9), (0, 11), (-9, -3), (-4, -2), (12, 10) /)

  integer :: n, i
  complex :: points(0:100)
  character(len = 100) :: fmt

  n = 20
  points(1:n) = example_points
  call find_convex_hull (n, points(1:n), n, points(1:n))

  write (fmt, '("(", I20, ''("(", F3.0, 1X, F3.0, ") ")'', ")")') n
  write (*, fmt) (points(i), i = 1, n)

end program convex_hull_task
