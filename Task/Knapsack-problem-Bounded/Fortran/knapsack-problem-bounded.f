module knapsack_mod
  implicit none

  !--------------------------------------------------------------------
  ! Define an item type with a name, weight, value, and available count.
  !--------------------------------------------------------------------
  type :: item
    character(len=24) :: name      ! Name (for display purposes)
    integer         :: weight     ! Weight of one copy of the item
    integer         :: value      ! Value of one copy of the item
    integer         :: count      ! Maximum number of copies available
  end type item

  !--------------------------------------------------------------------
  ! Define a parameter array of items.
  !--------------------------------------------------------------------
  type(item), parameter :: items(*) = [ &
       item("map                     ",   9, 150, 1), &
       item("compass                 ",  13,  35, 1), &
       item("water                   ", 153, 200, 2), &
       item("sandwich                ",  50,  60, 2), &
       item("glucose                 ",  15,  60, 2), &
       item("tin                     ",  68,  45, 3), &
       item("banana                  ",  27,  60, 3), &
       item("apple                   ",  39,  40, 3), &
       item("cheese                  ",  23,  30, 1), &
       item("beer                    ",  52,  10, 3), &
       item("suntan cream            ",  11,  70, 1), &
       item("camera                  ",  32,  30, 1), &
       item("T-shirt                 ",  24,  15, 2), &
       item("trousers                ",  48,  10, 2), &
       item("umbrella                ",  73,  40, 1), &
       item("waterproof trousers     ",  42,  70, 1), &
       item("waterproof overclothes  ",  43,  75, 1), &
       item("note-case               ",  22,  80, 1), &
       item("sunglasses              ",   7,  20, 1), &
       item("towel                   ",  18,  12, 2), &
       item("socks                   ",   4,  50, 1), &
       item("book                    ",  30,  10, 2)  &
  ]

contains

  !--------------------------------------------------------------------
  ! Function: knapsack
  !
  ! Description:
  !   Solves the bounded knapsack problem using dynamic programming.
  !   This version retains a two-dimensional DP table (m) and applies
  !   binary splitting to efficiently handle items available in multiple
  !   copies.
  !
  ! Input:
  !   w - Maximum weight capacity of the knapsack.
  !
  ! Output:
  !   s - An integer array (of size equal to the number of items)
  !       where s(i) indicates how many copies of item i are selected
  !       in the optimal solution.
  !--------------------------------------------------------------------
  function knapsack(w) result(s)
    integer, intent(in)    :: w           ! Knapsack capacity
    integer, allocatable   :: s(:)        ! Solution vector of item counts
    integer, allocatable   :: m(:,:)      ! DP table: m(i,j) is the maximum value using items 1..i with capacity j
    integer                :: n           ! Total number of items
    integer                :: i, j, v, k  ! Loop indices and temporary value

    ! Variables for binary splitting of the count of an item.
    integer                :: available   ! Remaining copies to process for the current item
    integer                :: r           ! Current binary splitting factor
    integer                :: k_group     ! Number of copies in the current group
    integer                :: group_weight ! Total weight of the current group (k_group * item weight)
    integer                :: group_value  ! Total value of the current group (k_group * item value)

    ! Determine the number of items available.
    n = size(items)

    ! Allocate the solution vector and DP table.
    ! DP table m is sized from row 0 (base case: no items) to n, and column 0 to w.
    allocate(s(n), m(0:n, 0:w))

    ! Initialize both the DP table and the solution vector to 0.
    m = 0
    s = 0

    !-------------------------------
    ! DP Table Construction
    !-------------------------------
    ! For each item i (from 1 to n), determine the best value achievable
    ! with a knapsack capacity from 0 to w.
    do i = 1, n

      ! First, copy the previous row into the current row.
      ! This means if we do not take any of item i, the value remains as before.
      do j = 0, w
        m(i, j) = m(i-1, j)
      end do

      ! Process item i using binary splitting:
      ! Instead of iterating k from 1 to items(i)%count one by one, we split
      ! the available copies into groups for an efficient "0/1 item" update.
      available = items(i)%count
      r = 1
      do while (available > 0)
        ! Use k_group copies, which is the minimum of the current binary factor and available copies.
        k_group = min(r, available)

        ! Compute group weight and value for k_group copies.
        group_weight = k_group * items(i)%weight
        group_value  = k_group * items(i)%value

        ! Perform a 0/1 knapsack update for this group.
        ! Loop backwards from capacity w down to group_weight so that each group
        ! is only used once. We update row i (which already contains m(i-1, :) as baseline).
        do j = w, group_weight, -1
          ! If adding this group improves the total value, update m(i,j).
          v = m(i, j - group_weight) + group_value
          if (v > m(i, j)) then
            m(i, j) = v
          end if
        end do

        ! Subtract the number of copies processed and double the binary factor.
        available = available - k_group
        r = r * 2
      end do

    end do

    !-------------------------------
    ! Backtracking to Retrieve the Solution
    !-------------------------------
    ! Starting from the maximum capacity and the last item, deduce how many copies
    ! of each item were used in the optimal solution.
    j = w
    do i = n, 1, -1
      ! Store the optimal value for items 1..i with current capacity j.
      v = m(i, j)
      ! For item i, try every possible count from 0 to items(i)%count.
      do k = 0, items(i)%count
        if (j >= k * items(i)%weight) then
          ! Check if the current value resulted from taking k copies of item i.
          if (v == m(i-1, j - k*items(i)%weight) + k*items(i)%value) then
            s(i) = k     ! Record k copies for item i
            j = j - k*items(i)%weight  ! Decrease the remaining capacity
            exit        ! Proceed to the next (previous) item
          end if
        end if
      end do
    end do

  end function knapsack

end module knapsack_mod

program main
    use knapsack_mod
    implicit none
    integer, allocatable :: s(:)
    integer :: i, total_count, total_weight, total_value

    s = knapsack(400)

    total_count = 0
    total_weight = 0
    total_value = 0

    write(*,'(A22  A6  A7  A6)') 'Item', 'Count', 'Weight', 'Value'
    write(*,'("------------------------------------------------")')

    do i = 1, size(items)
        if (s(i) > 0) then
            write(*,'(A22  I5  I6  I6)') &
                items(i)%name, s(i), s(i)*items(i)%weight, s(i)*items(i)%value
            total_count = total_count + s(i)
            total_weight = total_weight + s(i)*items(i)%weight
            total_value = total_value + s(i)*items(i)%value
        end if
    end do

    write(*,'("------------------------------------------------")')
    write(*,'(A22  I5  I6  I6)') 'Totals:', total_count, total_weight, total_value

end program main
