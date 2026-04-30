module statement_checker
   implicit none
   private
   public :: check_statements

contains
   subroutine check_statements(truth, is_valid, failed_count, failed_indices)
      logical, intent(in) :: truth(12)
      logical, intent(out) :: is_valid
      integer, intent(out) :: failed_count
      integer, intent(out) :: failed_indices(12)
      logical :: conditions(12)
      integer :: i, true_count, last_six_count, even_count, odd_count, first_six_count
      integer :: true_789_count

      ! Initialize
      failed_count = 0
      failed_indices = 0
      conditions = .false.

      ! Statement 1: This is a numbered list of twelve statements (always true)
      conditions(1) = .true.

      ! Statement 2: Exactly 3 of the last 6 statements (7 to 12) are true
      last_six_count = count(truth(7:12))
      conditions(2) = (last_six_count == 3)

      ! Statement 3: Exactly 2 of the even-numbered statements (2,4,6,8,10,12) are true
      even_count = count(truth([2, 4, 6, 8, 10, 12]))
      conditions(3) = (even_count == 2)

      ! Statement 4: If statement 5 is true, then statements 6 and 7 are both true
      conditions(4) = (.not.truth(5)) .or. (truth(6) .and. truth(7))

      ! Statement 5: The 3 preceding statements (2,3,4) are all false
      conditions(5) = (.not.truth(2)) .and. (.not.truth(3)) .and. (.not.truth(4))

      ! Statement 6: Exactly 4 of the odd-numbered statements (1,3,5,7,9,11) are true
      odd_count = count(truth([1, 3, 5, 7, 9, 11]))
      conditions(6) = (odd_count == 4)

      ! Statement 7: Either statement 2 or 3 is true, but not both
      conditions(7) = (truth(2) .neqv. truth(3))

      ! Statement 8: If statement 7 is true, then 5 and 6 are both true
      conditions(8) = (.not.truth(7)) .or. (truth(5) .and. truth(6))

      ! Statement 9: Exactly 3 of the first 6 statements are true
      first_six_count = count(truth(1:6))
      conditions(9) = (first_six_count == 3)

      ! Statement 10: The next two statements (11,12) are both true
      conditions(10) = truth(11) .and. truth(12)

      ! Statement 11: Exactly 1 of statements 7, 8, and 9 are true
      true_789_count = count(truth(7:9))
      conditions(11) = (true_789_count == 1)

      ! Statement 12: Exactly 4 of the preceding statements (1 to 11) are true
      true_count = count(truth(1:11))
      conditions(12) = (true_count == 4)

      ! Check if solution is valid (all conditions match truth values)
      is_valid = all(truth .eqv. conditions)

      ! Count failed statements and record their indices
      do i = 1, 12
         if (truth(i) .neqv. conditions(i)) then
            failed_count = failed_count + 1
            failed_indices(failed_count) = i
         end if
      end do
   end subroutine check_statements
end module statement_checker

program solve_statements
   use statement_checker
   implicit none
   logical :: truth(12)
   integer :: i, j, combo, failed_count, failed_indices(12), k
   logical :: is_valid
   integer :: valid_solutions(0:4095, 12)
   integer :: near_misses(0:4095, 13)
   integer :: valid_count, near_miss_count
   character(len=100) :: truth_str
   character(len=2) :: holder

   valid_count = 0
   near_miss_count = 0
   valid_solutions = 0
   near_misses = 0

   ! Iterate through all 2^12 combinations
   do combo = 0, 2**12 - 1
      ! Convert combo to binary truth array
      do i = 1, 12
         truth(i) = btest(combo, i - 1)
      end do

      ! Check statements
      call check_statements(truth, is_valid, failed_count, failed_indices)

      ! Store valid solutions
      if (is_valid) then
         valid_solutions(valid_count, 1:12) = merge(1, 0, truth)
         valid_count = valid_count + 1
      end if

      ! Store near-misses (exactly one statement false)
      if (failed_count == 1) then
         near_misses(near_miss_count, 1:12) = merge(1, 0, truth)
         near_misses(near_miss_count, 13) = failed_indices(1)
         near_miss_count = near_miss_count + 1
      end if
   end do

   ! Print valid solutions
   write(*, '(A)') 'Exact hits:'
   if (valid_count == 0) then
      write(*, '(A)') '    None'
   else
      do i = 0, valid_count - 1
         truth_str = ''
         do j = 1, 12
            if (valid_solutions(i, j) == 1) then
               write(holder, '(i0)') j
               holder = adjustl(holder)
               truth_str = trim(truth_str) // ' ' // holder
            end if
         end do
         write(*, '(A,A)') '    ', trim(truth_str)
      end do
   end if

   ! Print near-misses
   write(*, '(/A)') 'Near misses:'
   if (near_miss_count == 0) then
      write(*, '(A)') '    None'
   else
      do i = 0, near_miss_count - 1
         truth_str = ''
         do j = 1, 12
            if (near_misses(i, j) == 1) then
               !          WRITE(truth_str, '(A,I0,A)') TRIM(truth_str), j, '~'
               write(holder, '(i0)') j
               holder = adjustl(holder)
               truth_str = trim(truth_str) // ' ' // holder
            end if
         end do
         if (truth_str == '') then
            truth_str = 'None'
         end if
         !      call foobar(truth_str,len_trim(truth_str))
         write(*, '(A,I0,A,T28, A)') '    (Fails at statement ', near_misses(i, 13), ') ', trim(truth_str)
      end do
   end if
contains
   subroutine foobar(thing, n)
      implicit none
      integer, intent(in) :: n
      character(len=1), dimension(n) :: thing
      where (thing == '~') thing = ' '
      return
   end subroutine foobar
end program solve_statements
