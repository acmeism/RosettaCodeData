program standard_deviation
  implicit none
  integer(kind=4), parameter :: dp = kind(0.0d0)

  real(kind=dp), dimension(:), allocatable :: vals
  integer(kind=4) :: i

  real(kind=dp), dimension(8) :: sample_data = (/ 2, 4, 4, 4, 5, 5, 7, 9 /)

  do i = lbound(sample_data, 1), ubound(sample_data, 1)
    call sample_add(vals, sample_data(i))
    write(*, fmt='(''#'',I1,1X,''value = '',F3.1,1X,''stddev ='',1X,F10.8)') &
      i, sample_data(i), stddev(vals)
  end do

  if (allocated(vals)) deallocate(vals)
contains
  ! Adds value :val: to array :population: dynamically resizing array
  subroutine sample_add(population, val)
    real(kind=dp), dimension(:), allocatable, intent (inout) :: population
    real(kind=dp), intent (in) :: val

    real(kind=dp), dimension(:), allocatable :: tmp
    integer(kind=4) :: n

    if (.not. allocated(population)) then
      allocate(population(1))
      population(1) = val
    else
      n = size(population)
      call move_alloc(population, tmp)

      allocate(population(n + 1))
      population(1:n) = tmp
      population(n + 1) = val
    endif
  end subroutine sample_add

  ! Calculates standard deviation for given set of values
  real(kind=dp) function stddev(vals)
    real(kind=dp), dimension(:), intent(in) :: vals
    real(kind=dp) :: mean
    integer(kind=4) :: n

    n = size(vals)
    mean = sum(vals)/n
    stddev = sqrt(sum((vals - mean)**2)/n)
  end function stddev
end program standard_deviation
