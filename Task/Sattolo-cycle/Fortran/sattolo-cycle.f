program sattolo_test
  implicit none
! Uses automatic allocation of the array, "arr"
  integer, allocatable :: arr(:)
  integer :: i, n
  integer :: seed_size
  integer, allocatable :: seed(:)
  integer ,allocatable:: holder(:), results(:)

  ! -------------------------------------------------
  ! Seed the RNG properly (different result each run)
  ! -------------------------------------------------
  call random_seed(size=seed_size)
  allocate(seed(seed_size))
  call system_clock(count=i)
  seed = i + 37 * [(i, i = 1, seed_size)]
  call random_seed(put=seed)

  ! -------------------------------------------------
  ! Test 1: the 3-element example
  ! -------------------------------------------------
  arr = [10, 20, 30]
  holder = arr ! save for testing
  call sattolo_shuffle(arr)
  write(*,'("original data   : ",*(i0,1x))') holder
  write(*,'("3-element result: ",*(i0,1x))') arr
  results = ieor(holder,arr)
  if(any(results==0))then
      print*,'All not in unique position for 3 elements'
  endif
  ! -------------------------------------------------
  ! Test 2: the 12-element example from the task
  ! -------------------------------------------------
  n = 12
  arr = [(10 + i, i = 1, n)]          ! 11,12,…,22
  holder = arr ! save for testing
  call sattolo_shuffle(arr)
  write(*,'("original data    : ",*(i0,1x))') holder
  write(*,'("12-element result: ",*(i0,1x))') arr
  results = ieor(holder,arr)
  if(any(results==0))then
      print*,'All not in unique position for 12 elements'
  endif
  ! -------------------------------------------------
  ! Test 3: single element ? must stay unchanged
  ! -------------------------------------------------
  arr = [999]
  holder = arr
  call sattolo_shuffle(arr)
  write(*,'("original data   : ",*(i0,1x))') holder
  write(*,'("1-element result: ",*(i0,1x))') arr
  results = ieor(holder,arr)
  if(any(results==0))then
      print*,'All not in unique position for 1 elements (expected outcome)'
  endif
  ! -------------------------------------------------
  ! Test 4: two elements ? must always swap
  ! -------------------------------------------------
  arr = [100, 200]
  holder = arr
  call sattolo_shuffle(arr)
  write(*,'("original data   : ",*(i0,1x))') holder
  write(*,'("2-element result: ",*(i0,1x))') arr
  results = ieor(holder,arr)
  if(any(results==0))then
      write(*,'("All not in unique position for 2 elements")')
  endif
contains

  subroutine sattolo_shuffle(a)
    !! In-place Sattolo cycle for integer arrays.
    !! Works on any rank-1 contiguous integer array.
    integer, intent(inout), contiguous :: a(:)
    integer :: n, i, j, temp
    real    :: r

    n = size(a)
    if (n < 2) return

    ! Original Sattolo algorithm (right-to-left, j < i)
    do i = n, 2, -1
      call random_number(r)                  ! r ? [0,1)
      j = 1 + int(r * real(i - 1))             ! j ? 1 .. i-1  (uniform)
      temp = a(i)
      a(i) = a(j)
      a(j) = temp
    end do
  end subroutine sattolo_shuffle

end program sattolo_test

