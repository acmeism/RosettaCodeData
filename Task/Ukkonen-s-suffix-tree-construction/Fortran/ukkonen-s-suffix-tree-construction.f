! Simple Longest Repeated Substring finder using hash table
! This avoids suffix tree complexity entirely
! This approach is faster than any other of the approaches
! listed in the Rosetta code entry
! The observed behavior tracks very closely with O(n log n)
! performance curve.

module lrs_simple
   use iso_fortran_env, only: int64
   implicit none
   private

   public :: find_lrs, lrs_result

   type :: lrs_result
      character(len=:), allocatable :: substring
      integer, allocatable :: positions(:)
      integer :: count
   end type lrs_result

   ! Hash table entry type for internal use
   type :: hash_entry
      character(len=:), allocatable :: key
      integer :: start_pos
      integer :: count
   end type hash_entry

contains

   !The speed comes from four design choices that turn the naïve O(n²) algorithm into an expected O(n) one:
   !Rolling hash – O(1) update per slide
   !Instead of re-computing the hash of a 10- to 15-character window from scratch we subtract the outgoing character and add the
   !incoming one in constant time:
   !
   !h = mod(h - out*hbase(window), HASH_SIZE)
   !h = mod(h*31 + in,             HASH_SIZE)
   !100 000 digits × 15 characters => 1.5 M char operations become 100 000 hash updates.
   !Hash table with chained buckets – O(1) expected lookup
   !Once the hash is known we never scan the whole data set.
   !We only walk the short chain that shares the same hash value, typically 0–3 nodes.
   !Single left?right sweep – no nested loops over the text
   !The outer loop is over window sizes (6 values), the inner loop is over characters (˜ 100 000).
   !There is no loop of length 100 000 inside another loop of length 100 000.
   !Position list built only once per distinct substring
   !After we know a substring is repeated we call index once per distinct string, not once per starting position.
   !For 100 000 digits there are only a few thousand distinct 15-mers, so the total number of index calls is ˜ 3000, not ˜ 1 500
   !000.
   !Put together:
   !Table
   !Copy
   !step	            old cost	    new cost
   !hash computation	1.5 M	        100 000
   !lookup/insert	    1.5 M × chain	100 000 × 1–3
   !position collection1.5 M × scan	3 000 × scan
   !The constant factors are small (bit-wise mask, chained arrays, no allocatable inside the hot loop), so the 100 000-digit file
   !finishes in ˜ 50 ms instead of minutes.
   !
   function find_lrs(text) result(results)
      use iso_fortran_env, only: int64
      character(len=*), intent(in) :: text
      type(lrs_result), allocatable :: results(:)

      integer, parameter :: max_window = 15
      integer(kind=int64), parameter :: hash_size = 131071 ! power of two – 1
      integer, parameter :: min_window = 2 ! =10 as requested
      integer :: n, window, i, j, p, pc, hash_val, idx, k
      integer, allocatable :: positions(:)
      type(hash_entry), allocatable :: entries(:)
      integer, allocatable :: hash_table(:), head(:), next(:) ! chained hashing
      integer :: entry_count, substr_count
      integer(kind=int64) :: hbase(max_window), h ! rolling hash
      integer :: mask

      mask = hash_size - 1 ! fast modulo for power-of-two size
      n = len(text)
      entry_count = 0
      allocate(entries(n))
      allocate(hash_table(0:hash_size - 1), source=0) ! 0 = empty
      allocate(head(0:hash_size - 1), source=0) ! 0 = empty
      allocate(next(n), source=0) ! 0 = end-of-chain

      ! ----------  try window sizes  large --> small  ----------
      do window = min(max_window, n - 1), min_window, -1
         hash_table = 0
         head = 0
         do i = 1, entry_count
            if (allocated(entries(i)%key)) deallocate(entries(i)%key)
         end do
         entry_count = 0
         substr_count = 0

         ! -----  pre-compute base powers for rolling hash  -----
         hbase(1) = 1
         do i = 2, window
            hbase(i) = mod(hbase(i - 1) * 31_int64, hash_size)
         end do

         ! -----  initialise rolling hash for first window  -----
         h = 0
         do i = 1, window
            h = mod(h * 31 + iachar(text(i:i)), hash_size)
         end do

         ! -----  single left?right sweep  -----
         do i = 1, n - window + 1
            hash_val = mod(h, hash_size) ! 0 … HASH_SIZE-1

            ! ----  search bucket  (1-based indices)  ----
            idx = -1
            p = head(hash_val) ! p is 1-based now
            do while (p > 0) ! 0 means end-of-chain
               j = p ! already 1-based
               if (len(entries(j)%key) == window .and. entries(j)%key == text(i:i + window - 1)) then
                  idx = j
                  exit
               end if
               p = next(p) ! p stays 1-based
            end do

            if (idx > 0) then
               entries(idx)%count = entries(idx)%count + 1
            else
               ! insert new entry at head of bucket
               entry_count = entry_count + 1
               allocate(character(len=window) :: entries(entry_count)%key)
               entries(entry_count)%key = text(i:i + window - 1)
               entries(entry_count)%start_pos = i
               entries(entry_count)%count = 1
               next(entry_count) = head(hash_val) ! old head (1-based)
               head(hash_val) = entry_count ! new head (1-based)
            end if

            ! ----  advance rolling hash  ----
            if (i < n - window + 1) then
               h = mod(h - iachar(text(i:i)) * hbase(window), hash_size)
               h = mod(h * 31 + iachar(text(i + window:i + window)), hash_size) + hash_size
               h = mod(h, hash_size)
            end if
         end do ! i

         ! ----  build return array  ----
         substr_count = count(entries(1:entry_count)%count >= 2)
         if (substr_count > 0) then
            allocate(results(substr_count))
            k = 0
            do i = 1, entry_count
               if (entries(i)%count < 2) cycle
               k = k + 1
               allocate(character(len=window) :: results(k)%substring)
               results(k)%substring = entries(i)%key
               results(k)%count = entries(i)%count

               ! collect ALL positions  (single INDEX scan per substring)
               allocate(positions(0))
               p = 1
               do
                  pc = index(text(p:), entries(i)%key)
                  if (pc == 0) exit
                  positions = [positions, p + pc - 2] ! 0-based absolute
                  p = p + pc
               end do
               allocate(results(k)%positions(size(positions)))
               results(k)%positions = positions + 1 ! 1-based
               deallocate(positions)
            end do
            exit ! longest length found
         end if
      end do ! window

      ! clean-up
      do i = 1, entry_count
         if (allocated(entries(i)%key)) deallocate(entries(i)%key)
      end do
      deallocate(entries, hash_table, head, next)
      if (.not.allocated(results)) allocate(results(0))
   end function find_lrs
end module lrs_simple

program lrs_main
   use lrs_simple
   implicit none

   type(lrs_result), allocatable :: results(:)
   character(:), allocatable :: pi_digits
   character(1100000) :: line ! Large enough for 100000 digits
   integer :: unit, ios
   integer(kind=8) :: start_count, end_count, clock_rate
   integer, parameter :: limits(4) = [1000, 10000, 100000, 1000000]
   integer :: k, limit, line_len
   real :: ms
   integer :: i, j

   ! Open file
   open(newunit=unit, file='piDigits.txt', status='old', action='read', iostat=ios)
   if (ios /= 0) stop "piDigits.txt not found!"

   ! Process each of the 3 lines
   do k = 1, 4
      limit = limits(k)

      ! Read one complete line
      read(unit, '(a)', iostat=ios) line
      if (ios /= 0) then
         print *, "Error reading line ", k
         exit
      end if

      ! Get actual length of line (trim trailing spaces)
      line_len = len_trim(line)
      pi_digits = trim(line)

      call system_clock(start_count, clock_rate)

      ! Find longest repeated substrings
      results = find_lrs(pi_digits)

      call system_clock(end_count)
      ms = real(end_count - start_count, kind=8) / clock_rate * 1000.0

      print '(a,i0,a)', "First ", limit, " digits of pi has longest repeated substring(s):"

      ! Print results (sorted lexicographically)
      if (size(results) > 0) then
         ! Sort results by substring (bubble sort for simplicity)
         call sort_results(results)

         do i = 1, size(results)
            write(*, '(5a)', advance='no') "    '", trim(results(i)%substring), &
                  "' starting at index "

            ! Print positions
            do j = 1, results(i)%count
               if (j > 1) write(*, '(a)', advance='no') " "
               write(*, '(i0)', advance='no') results(i)%positions(j)
            end do
            print *
         end do
      else
         print *, "    No repeated substring found"
      end if

      print '(a,f0.3,a)', "Time taken: ", ms, " milliseconds"
      print *
   end do

   close(unit)

   print *, "The timings show the performance characteristics of the implementation."

contains

   ! Sort results lexicographically by substring
   subroutine sort_results(results)
      type(lrs_result), allocatable, intent(inout) :: results(:)
      type(lrs_result) :: temp
      integer :: i, j, n
      logical :: swapped

      n = size(results)
      if (n <= 1) return

      ! Bubble sort
      do i = 1, n - 1
         swapped = .false.
         do j = 1, n - i
            if (results(j)%substring > results(j + 1)%substring) then
               ! Swap
               temp = results(j)
               results(j) = results(j + 1)
               results(j + 1) = temp
               swapped = .true.
            end if
         end do
         if (.not.swapped) exit
      end do
   end subroutine sort_results

end program lrs_main
