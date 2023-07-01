module rosetta_code_patience_sort
  implicit none
  private

  public :: patience_sort

  interface
     function binary_predicate (x, y) result (truth)
       class(*), intent(in) :: x, y
       logical :: truth
     end function binary_predicate
  end interface

contains

  function patience_sort (less, ifirst, ilast, array) result (sorted)
    procedure(binary_predicate) :: less
    integer, intent(in) :: ifirst, ilast
    class(*), intent(in) :: array(*)
    integer, allocatable :: sorted(:)

    !
    ! Returns a sorted list of indices.
    !

    integer :: num_piles
    integer, allocatable :: piles(:)
    integer, allocatable :: links(:)

    ! We shall build the piles as linked lists stored as arrays of
    ! element indices. The indices are normalized to run from 1 to
    ! ifirst-ilast+1. The "piles" array stores the heads, and the
    ! "links" array stores the rest of each list. A null link is
    ! represented by zero.
    allocate (piles(1 : ilast - ifirst + 1), source = 0)
    allocate (links(1 : ilast - ifirst + 1), source = 0)

    num_piles = 0
    call deal (less, ifirst, ilast, array, num_piles, piles, links)

    allocate (sorted(1 : ilast - ifirst + 1))

    call k_way_merge (less, ifirst, ilast, array, num_piles, piles, &
         &            links, sorted)

  end function patience_sort

  subroutine deal (less, ifirst, ilast, array, &
       &           num_piles, piles, links)
    procedure(binary_predicate) :: less
    integer, intent(in) :: ifirst, ilast
    class(*), intent(in) :: array(*)
    integer, intent(inout) :: num_piles
    integer, intent(inout) :: piles(1 : ilast - ifirst + 1)
    integer, intent(inout) :: links(1 : ilast - ifirst + 1)

    integer :: i, q

    do q = 1, ilast - ifirst + 1
       i = find_pile (q)
       links(q) = piles(i)
       piles(i) = q
       num_piles = max (num_piles, i)
    end do

  contains

    function find_pile (q) result (index)
      integer, value :: q
      integer :: index

      !
      ! Bottenbruch search for the leftmost pile whose top is greater
      ! than or equal to x. Return an index such that:
      !
      !   * if x is greater than the top element at the far right,
      !     then the index returned will be num-piles.
      !
      !   * otherwise, x is greater than every top element to the left
      !     of index, and less than or equal to the top elements at
      !     index and to the right of index.
      !
      ! References:
      !
      !   * H. Bottenbruch, "Structure and use of ALGOL 60", Journal
      !     of the ACM, Volume 9, Issue 2, April 1962, pp.161-221.
      !     https://doi.org/10.1145/321119.321120
      !
      !     The general algorithm is described on pages 214 and 215.
      !
      !   * https://en.wikipedia.org/w/index.php?title=Binary_search_algorithm&oldid=1062988272#Alternative_procedure
      !

      integer :: i, j, k

      if (num_piles == 0) then
         index = 1
      else
         j = 0
         k = num_piles - 1
         do while (j /= k)
            i = (j + k) / 2
            if (less (array(piles(j + 1) + ifirst - 1), &
                 &    array(q + ifirst - 1))) then
               j = i + 1
            else
               k = i
            end if
         end do
         if (j == num_piles - 1) then
            if (less (array(piles(j + 1) + ifirst - 1), &
                 &    array(q + ifirst - 1))) then
               ! A new pile is needed.
               j = j + 1
            end if
         end if
         index = j + 1
      end if
    end function find_pile

  end subroutine deal

  subroutine k_way_merge (less, ifirst, ilast, array, num_piles, &
       &                  piles, links, sorted)
    procedure(binary_predicate) :: less
    integer, intent(in) :: ifirst, ilast
    class(*), intent(in) :: array(*)
    integer, intent(in) :: num_piles
    integer, intent(inout) :: piles(1 : ilast - ifirst + 1)
    integer, intent(inout) :: links(1 : ilast - ifirst + 1)
    integer, intent(inout) :: sorted(1 : ilast - ifirst + 1)

    !
    ! k-way merge by tournament tree.
    !
    ! See Knuth, volume 3, and also
    ! https://en.wikipedia.org/w/index.php?title=K-way_merge_algorithm&oldid=1047851465#Tournament_Tree
    !
    ! However, I store a winners tree instead of the recommended
    ! losers tree. If the tree were stored as linked nodes, it would
    ! probably be more efficient to store a losers tree. However, I am
    ! storing the tree as an array, and one can find an opponent
    ! quickly by simply toggling the least significant bit of a
    ! competitor's array index.
    !

    integer :: total_external_nodes
    integer :: total_nodes
    integer :: winners(1:2, 1:(2 * next_power_of_two (num_piles)) - 1)
    integer :: isorted, i, next

    total_external_nodes = next_power_of_two (num_piles)
    total_nodes = (2 * total_external_nodes) - 1

    call build_tree

    isorted = 0
    do while (winners(1, 1) /= 0)
       isorted = isorted + 1
       sorted(isorted) = winners(1, 1) + ifirst - 1
       i = winners(2, 1)
       next = piles(i)          ! The next top of pile i.
       if (next /= 0) piles(i) = links(next) ! Drop that top.
       i = (total_nodes / 2) + i
       winners(1, i) = next
       call replay_games (i)
    end do

  contains

    subroutine build_tree
      integer :: i
      integer :: istart
      integer :: iwinner

      winners = 0

      do i = 1, total_external_nodes
         ! Record which pile a winner will have come from.
         winners(2, total_external_nodes - 1 + i) = i
      end do

      ! The top of each pile becomes a starting competitor.
      winners(1, total_external_nodes :                  &
           &     total_external_nodes + num_piles - 1) = &
           &  piles(1:num_piles)

      do i = 1, num_piles
         ! Discard the top of each pile
         piles(i) = links(piles(i))
      end do

      istart = total_external_nodes
      do while (istart /= 1)
         do i = istart, (2 * istart) - 1, 2
            iwinner = play_game (i)
            winners(:, i / 2) = winners(:, iwinner)
         end do
         istart = istart / 2
      end do
    end subroutine build_tree

    subroutine replay_games (i)
      integer, value :: i

      integer :: iwinner

      do while (i /= 1)
         iwinner = play_game (i)
         i = i / 2
         winners(:, i) = winners(:, iwinner)
      end do
    end subroutine replay_games

    function play_game (i) result (iwinner)
      integer, value :: i
      integer :: iwinner

      integer :: j

      j = ieor (i, 1)
      if (winners(1, i) == 0) then
         iwinner = j
      else if (winners(1, j) == 0) then
         iwinner = i
      else if (less (array(winners(1, j) + ifirst - 1), &
           &         array(winners(1, i) + ifirst - 1))) then
         iwinner = j
      else
         iwinner = i
      end if
    end function play_game

  end subroutine k_way_merge

  elemental function next_power_of_two (n) result (pow2)
    integer, value :: n
    integer :: pow2

    ! This need not be a fast implementation.
    pow2 = 1
    do while (pow2 < n)
       pow2 = pow2 + pow2
    end do
  end function next_power_of_two

end module rosetta_code_patience_sort

program patience_sort_task
  use, non_intrinsic :: rosetta_code_patience_sort
  implicit none

  integer, parameter :: example_numbers(*) =               &
       & (/ 22, 15, 98, 82, 22, 4, 58, 70, 80, 38, 49, 48, &
       &    46, 54, 93, 8, 54, 2, 72, 84, 86, 76, 53, 37,  &
       &    90 /)

  integer :: i
  integer, allocatable :: sorted(:)

  sorted = patience_sort (less, &
       &                  lbound (example_numbers, 1), &
       &                  ubound (example_numbers, 1), &
       &                  example_numbers)

  write (*, '("unsorted  ")', advance = 'no')
  do i = lbound (example_numbers, 1), ubound (example_numbers, 1)
     write (*, '(1X, I0)', advance = 'no') example_numbers(i)
  end do
  write (*, '()')
  write (*, '("sorted    ")', advance = 'no')
  do i = lbound (sorted, 1), ubound (sorted, 1)
     write (*, '(1X, I0)', advance = 'no') example_numbers(sorted(i))
  end do
  write (*, '()')

contains

  function less (x, y) result (truth)
    class(*), intent(in) :: x, y
    logical :: truth

    select type (x)
    type is (integer)
       select type (y)
       type is (integer)
          truth = (x < y)
       class default
          error stop
       end select
    class default
       error stop
    end select
  end function less

end program patience_sort_task
