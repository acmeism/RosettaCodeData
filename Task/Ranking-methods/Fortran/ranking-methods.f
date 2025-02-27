module ranking_methods
  implicit none
  private
  public :: standard_ranking, modified_ranking, dense_ranking, ordinal_ranking, fractional_ranking

contains

  subroutine standard_ranking(scores, names, ranks)
  implicit none
    real, intent(in) :: scores(:)
    character(len=*), intent(in) :: names(:)
    real, allocatable, intent(out) :: ranks(:)
    integer :: i, n

    n = size(scores)
    allocate(ranks(n))
    ranks(1) = 1.0
    do i = 2, n
        ranks(i) = MERGE(ranks(i-1), REAL(i), scores(i) == scores(i-1))
    end do
  end subroutine standard_ranking

  subroutine modified_ranking(scores, names, ranks)
  implicit none
    real, intent(in) :: scores(:)
    character(len=*), intent(in) :: names(:)
    real, allocatable, intent(out) :: ranks(:)
    integer :: i, j, n

    n = size(scores)
    allocate(ranks(n))
    do i = 1, n
      ranks(i) = real(i)
      do j = i+1, n
        if (scores(j) == scores(i)) then
          ranks(j) = ranks(i)
        end if
      end do
    end do
  end subroutine modified_ranking

  subroutine dense_ranking(scores, names, ranks)
  implicit none
    real, intent(in) :: scores(:)
    character(len=*), intent(in) :: names(:)
    real, allocatable, intent(out) :: ranks(:)
    integer :: i, n
    real :: current_rank

    n = size(scores)
    allocate(ranks(n))
    current_rank = 1.0
    ranks(1) = current_rank
    do i = 2, n
      if (scores(i) /= scores(i-1)) then
        current_rank = current_rank + 1
      end if
      ranks(i) = current_rank
    end do
  end subroutine dense_ranking


  subroutine ordinal_ranking(scores, names, ranks)
    real, intent(in) :: scores(:)
    character(len=*), intent(in) :: names(:)
    real, allocatable, intent(out) :: ranks(:)
    integer :: i, n

    n = size(scores)
    allocate(ranks(n))
    do i = 1, n
      ranks(i) = real(i)
    end do
  end subroutine ordinal_ranking

subroutine fractional_ranking(scores, names, ranks)
  implicit none
  real, intent(in) :: scores(:)
  character(len=*), intent(in) :: names(:)
  real, allocatable, intent(out) :: ranks(:)
  integer :: i, j, n
  real :: sum_rank

  n = size(scores)
  allocate(ranks(n))

  i = 1
  do while (i <= n)
    sum_rank = real(i)
    j = i + 1
    do while (j <= n .and. scores(j) == scores(i))
      sum_rank = sum_rank + real(j)
      j = j + 1
    end do
    ranks(i:j-1) = sum_rank / (j - i)
    i = j
  end do
end subroutine fractional_ranking


program main
  use ranking_methods
  implicit none

  real, dimension(7) :: scores = [44.0, 42.0, 42.0, 41.0, 41.0, 41.0, 39.0]
  character(len=10), dimension(7) :: names = ["Solomon   ", "Jason     ", "Errol     ", &
                                              "Garry     ", "Bernard   ", "Barry     ", "Stephen   "]
  real, allocatable :: ranks(:)
  integer :: i

  print *, "Standard Ranking:"
  call standard_ranking(scores, names, ranks)
  call print_results(scores, names, ranks)

  print *, "Modified Ranking:"
  call modified_ranking(scores, names, ranks)
  call print_results(scores, names, ranks)

  print *, "Dense Ranking:"
  call dense_ranking(scores, names, ranks)
  call print_results(scores, names, ranks)

  print *, "Ordinal Ranking:"
  call ordinal_ranking(scores, names, ranks)
  call print_results(scores, names, ranks)

  print *, "Fractional Ranking:"
  call fractional_ranking(scores, names, ranks)
  call print_results(scores, names, ranks)

contains

  subroutine print_results(scores, names, ranks)
    real, intent(in) :: scores(:), ranks(:)
    character(len=*), intent(in) :: names(:)
    integer :: i

    do i = 1, size(scores)
      print '(F5.1, 2X, A10, 2X, F5.1)', scores(i), names(i), ranks(i)
    end do
    print *
  end subroutine print_results

end program main
end module ranking_methods
