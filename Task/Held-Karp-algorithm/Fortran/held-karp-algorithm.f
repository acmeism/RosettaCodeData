module heldkarp
  use iso_fortran_env, only: real64, int16
  implicit none
  private
  public :: held_karp
contains

  subroutine held_karp(ncity, dist, tour, min_cost)
    !! Exact TSP solver (Held–Karp dynamic programming)
    !! Cities are numbered 0 .. ncity-1, start city is 0
    !! dist is a full n×n matrix (symmetric or asymmetric both work)
    !! tour(0:ncity-1) returns the order 0 -> best_last -> 0
    !! min_cost is the minimum tour length
    integer, intent(in) :: ncity
    real(real64), intent(in) :: dist(0:ncity-1, 0:ncity-1)
    integer, intent(out) :: tour(0:ncity-1)
    real(real64), intent(out) :: min_cost

    real(real64), parameter :: inf = huge(1.0_real64)
    real(real64), allocatable :: dp(:,:)
    integer(int16), allocatable :: parent(:,:)
    integer :: full_mask, mask, subset, prev, last, i

    real(real64) :: new_cost
    integer :: best_last

    if (ncity <= 1) then
      min_cost = 0.0_real64
      tour(0) = 0
      return
    end if

    full_mask = ishft(1, ncity) - 1

    allocate(dp(0:ncity-1, 0:full_mask))
    allocate(parent(0:ncity-1, 0:full_mask))

    dp = inf
    parent = -1_int16

    ! starting city 0, visited mask = 1<<0, cost 0
    dp(0, 1) = 0.0_real64   ! mask 1 = 1<<0

    do mask = 0, full_mask
      if (.not. btest(mask, 0)) cycle   ! only masks that contain city 0

      do last = 1, ncity-1   ! never update ending at start except initial state
        if (.not. btest(mask, last)) cycle

        subset = ibclr(mask, last)   ! mask without current last

        do prev = 0, ncity-1
          if (prev == last) cycle
          if (.not. btest(subset, prev)) cycle

          new_cost = dp(prev, subset) + dist(prev, last)

          if (new_cost < dp(last, mask)) then
            dp(last, mask) = new_cost
            parent(last, mask) = int(prev, int16)
          end if
        end do
      end do
    end do

    ! find best return to city 0
    min_cost = inf
    best_last = -1

    do last = 1, ncity-1
      new_cost = dp(last, full_mask) + dist(last, 0)
      if (new_cost < min_cost) then
        min_cost = new_cost
        best_last = last
      end if
    end do

    ! reconstruct the path by backtracking parent table
    mask = full_mask
    last = best_last

    tour(0) = 0
    do i = ncity-1, 1, -1
      tour(i) = last
      last = parent(last, mask)
      mask = ibclr(mask, tour(i))   ! remove the bit of the city we just added
    end do

    ! optional output
    print *, "Held-Karp minimum tour cost:", min_cost
    write(*, '(a)', advance='no') "Optimal tour: "
    do i = 0, ncity-1
      write(*, '(i0,a)', advance='no') tour(i), " -> "
    end do
    print *, tour(0)

    deallocate(dp, parent)
  end subroutine held_karp
end module heldkarp

! Example program with the standard 4-city instance from Rosetta Code
program test_heldkarp
  use iso_fortran_env
  use heldkarp
  implicit none

  integer, parameter :: n = 4
  real(real64) :: dist(0:n-1, 0:n-1) = reshape( &
    [real(real64) ::  0.,  2.,  9., 10., &
       1.,  0.,  6.,  4., &
      15.,  7.,  0.,  8., &
       6.,  3., 12.,  0. ], [n, n])

  integer :: tour(0:n-1)
  real(real64) :: min_cost

  call held_karp(n, dist, tour, min_cost)

end program test_heldkarp
