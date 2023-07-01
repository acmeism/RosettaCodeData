      program TestMergeSort
        implicit none
        integer, parameter :: N = 8
        integer :: A(N) = (/ 1, 5, 2, 7, 3, 9, 4, 6 /)
        integer :: work((size(A) + 1) / 2)
        write(*,'(A,/,10I3)')'Unsorted array :',A
        call MergeSort(A, work)
        write(*,'(A,/,10I3)')'Sorted array :',A
      contains

      subroutine merge(A, B, C)
        implicit none
! The targe attribute is necessary, because A .or. B might overlap with C.
        integer, target, intent(in) :: A(:), B(:)
        integer, target, intent(inout) :: C(:)
        integer :: i, j, k

        if (size(A) + size(B) > size(C)) stop(1)

        i = 1; j = 1
        do k = 1, size(C)
          if (i <= size(A) .and. j <= size(B)) then
            if (A(i) <= B(j)) then
              C(k) = A(i)
              i = i + 1
            else
              C(k) = B(j)
              j = j + 1
            end if
          else if (i <= size(A)) then
            C(k) = A(i)
            i = i + 1
          else if (j <= size(B)) then
            C(k) = B(j)
            j = j + 1
          end if
        end do
      end subroutine merge

      subroutine swap(x, y)
        implicit none
        integer, intent(inout) :: x, y
        integer :: tmp
        tmp = x; x = y; y = tmp
      end subroutine

      recursive subroutine MergeSort(A, work)
        implicit none
        integer, intent(inout) :: A(:)
        integer, intent(inout) :: work(:)
        integer :: half
        half = (size(A) + 1) / 2
        if (size(A) < 2) then
          continue
        else if (size(A) == 2) then
          if (A(1) > A(2)) then
            call swap(A(1), A(2))
          end if
        else
          call MergeSort(A( : half), work)
          call MergeSort(A(half + 1 :), work)
          if (A(half) > A(half + 1)) then
            work(1 : half) = A(1 : half)
            call merge(work(1 : half), A(half + 1:), A)
          endif
        end if
      end subroutine MergeSort
      end program TestMergeSort
