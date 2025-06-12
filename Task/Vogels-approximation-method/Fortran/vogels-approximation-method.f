program vogels_approximation_method
  implicit none
  integer, parameter :: m = 4, n = 5
  integer :: costs(m,n), supply(m), demand(n)
  integer :: allocation(m,n), i, total_cost

  ! Initialize data
  costs = reshape([16,14,19,50, 16,14,19,12, 13,13,20,50, 22,19,23,15, 17,15,50,11], [m,n])
  supply = [50, 60, 50, 50]
  demand = [30, 20, 70, 30, 60]

  ! Perform VAM
  call vam(costs, supply, demand, allocation)

  ! Calculate and print total cost
  total_cost = sum(costs * allocation)
  print *, "Total cost: ", total_cost

  ! Print allocation
  print *, "Allocation:"
  do i = 1, m
    print *, allocation(i,:)
  end do

contains

  subroutine vam(costs, supply, demand, allocation)
    integer, intent(in) :: costs(m,n)
    integer, intent(inout) :: supply(m), demand(n)
    integer, intent(out) :: allocation(m,n)
    integer :: row_penalties(m), col_penalties(n)
    integer :: i, j, max_penalty, max_index, min_cost, alloc
    logical :: row_done(m), col_done(n)

    allocation = 0
    row_done = .false.
    col_done = .false.

    do while (any(.not. row_done) .and. any(.not. col_done))
      ! Calculate penalties
      call calculate_penalties(costs, row_done, col_done, row_penalties, col_penalties)

      ! Find maximum penalty
      max_penalty = max(maxval(row_penalties), maxval(col_penalties))
      if (maxval(row_penalties) >= maxval(col_penalties)) then
        max_index = maxloc(row_penalties, dim=1)
        min_cost = minval(costs(max_index, :), mask=.not. col_done)
        j = minloc(costs(max_index, :), dim=1, mask=.not. col_done)
        i = max_index
      else
        max_index = maxloc(col_penalties, dim=1)
        min_cost = minval(costs(:, max_index), mask=.not. row_done)
        i = minloc(costs(:, max_index), dim=1, mask=.not. row_done)
        j = max_index
      end if

      ! Allocate
      alloc = min(supply(i), demand(j))
      allocation(i,j) = alloc
      supply(i) = supply(i) - alloc
      demand(j) = demand(j) - alloc

      ! Update done flags
      if (supply(i) == 0) row_done(i) = .true.
      if (demand(j) == 0) col_done(j) = .true.
    end do
  end subroutine vam

  subroutine calculate_penalties(costs, row_done, col_done, row_penalties, col_penalties)
    integer, intent(in) :: costs(m,n)
    logical, intent(in) :: row_done(m), col_done(n)
    integer, intent(out) :: row_penalties(m), col_penalties(n)
    integer :: i, j, min1, min2

    do i = 1, m
      if (.not. row_done(i)) then
        min1 = minval(costs(i,:), mask=.not. col_done)
        min2 = minval(costs(i,:), mask=(.not. col_done .and. costs(i,:) > min1))
        row_penalties(i) = min2 - min1
      else
        row_penalties(i) = -1
      end if
    end do

    do j = 1, n
      if (.not. col_done(j)) then
        min1 = minval(costs(:,j), mask=.not. row_done)
        min2 = minval(costs(:,j), mask=(.not. row_done .and. costs(:,j) > min1))
        col_penalties(j) = min2 - min1
      else
        col_penalties(j) = -1
      end if
    end do
  end subroutine calculate_penalties

end program vogels_approximation_method
