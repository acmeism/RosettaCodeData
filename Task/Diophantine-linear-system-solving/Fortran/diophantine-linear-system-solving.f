! Subject: Solution of an m x n linear Diophantine system
!          A*x = b using LLL reduction.
! Ref.   : G. Havas, B. Majewski, K. Matthews,
!          'Extended gcd and Hermite normal form
!           algorithms via lattice basis reduction,'
!          Experimental Mathematics 7 (1998), no.2, pp.125-136
! Translated from FreeBASIC 1.08.1

module dioph_mod
    use iso_fortran_env,only:real64,int64
   implicit none

   logical, parameter :: echo_flag = .true.
   integer(kind=int64), parameter :: aln = 80, ald = 81

   integer(kind=int64) :: m1, mn, nx, m, n
   integer(kind=int64) :: c1, c2

   real(kind=real64), allocatable :: la(:, :), d(:)
   real(kind=real64), allocatable :: a(:, :)

contains

   ! Digit count of |x| (no sign), minimum 1
   integer(kind=int64) function dlen(x)
      real(kind=real64), intent(in) :: x
      character(len=64) :: tmp
      write(tmp, '(I0)') int(abs(x), kind=8)
      dlen = len_trim(tmp)
   end function dlen

   ! Build row r into a string using per-column widths p_arr.
   ! Each column occupies p_arr(s)+2 chars, matching FreeBASIC layout:
   ! positive: (p-l+1) spaces + sign-space + digits
   ! negative: (p-l+1) spaces + minus       + digits
   ! implemented via Fortran I(p+2) right-justification.
   ! Negative zero (-0.0d0) is preserved as '-0' to match FreeBASIC output.
   function row_str(r, p_arr) result(line)
      integer(kind=int64), intent(in) :: r
      integer(kind=int64), intent(in) :: p_arr(0:)
      character(len=4096) :: line
      character(len=64) :: tmp, fmt
      integer(kind=int64) :: s, w, pos, ival
      integer :: wi
      real(kind=real64) :: rv
      line = ' '
      pos = 1
      do s = 0, mn
         if (s == m1) then
            line(pos:pos + 1) = ' |'
            pos = pos + 2
         end if
         w = p_arr(s) + 2
         wi = int(w, kind=4)
         rv = a(r, s)
         ival = int(rv, kind=8)
         if (ival == 0_int64 .and. sign(1.0d0, rv) < 0.0d0) then
            ! Negative zero: right-justify '-0' in a field of width w
            tmp = repeat(' ', wi - 2) // '-0'
         else
            write(fmt, '(A,I0,A)') '(I', w, ')'
            write(tmp, fmt) ival
         end if
         line(pos:pos + wi - 1) = tmp(1:wi)
         pos = pos + w
      end do
   end function row_str

   ! Parse first number from string
   real(kind=real64) function val_d(s)
      character(len=*), intent(in) :: s
      integer(kind=int64) :: ios
      read(s, *, iostat=ios) val_d
      if (ios /= 0) val_d = 0.0d0
   end function val_d

   ! Position of first char from set 'chars' in s, 0 if not found
   integer(kind=int64) function instr_any(s, chars)
      character(len=*), intent(in) :: s, chars
      integer(kind=int64) :: i, j
      instr_any = 0
      do i = 1, len_trim(s)
         do j = 1, len(chars)
            if (s(i:i) == chars(j:j)) then
               instr_any = i
               return
            end if
         end do
      end do
   end function instr_any

   ! Negate row t in a() and update la()
   subroutine minus_row(t)
      integer(kind=int64), intent(in) :: t
      integer(kind=int64) :: r, s
      do s = 0, mn
         a(t, s) = -a(t, s)
      end do
      do r = 1, m
         do s = 0, r - 1
            if (r == t .or. s == t) la(r, s) = -la(r, s)
         end do
      end do
   end subroutine minus_row

   ! LLL size-reduce row k with respect to row t
   subroutine reduce_row(k, t)
      integer(kind=int64), intent(in) :: k, t
      integer(kind=int64) :: s, sx
      real(kind=real64) :: lk, q

      c1 = nx
      c2 = nx

      do s = m1, mn
         if (a(t, s) /= 0.0d0) then
            c1 = s
            exit
         end if
      end do
      do s = m1, mn
         if (a(k, s) /= 0.0d0) then
            c2 = s
            exit
         end if
      end do

      q = 0.0d0
      if (c1 < nx) then
         if (a(t, c1) < 0.0d0) call minus_row(t)
         q = floor(a(k, c1) / a(t, c1), kind=8)
      else
         lk = la(k, t)
         if (2.0d0 * abs(lk) > d(t)) &
               q = floor(lk / d(t) + 0.499d0, kind=8)
      end if

      if (q /= 0.0d0) then
         sx = mn
         if (c1 == nx) sx = m
         do s = 0, sx
            a(k, s) = a(k, s) - q * a(t, s)
         end do
         la(k, t) = la(k, t) - q * d(t)
         do s = 0, t - 1
            la(k, s) = la(k, s) - q * la(t, s)
         end do
      end if
   end subroutine reduce_row

   ! Swap rows k and k-1, update Gram coefficients
   subroutine swop_rows(k)
      integer(kind=int64), intent(in) :: k
      integer(kind=int64) :: r, s, t
      real(kind=real64) :: db, lk, lr, tmp

      t = k - 1

      do s = 0, mn
         tmp = a(k, s)
         a(k, s) = a(t, s)
         a(t, s) = tmp
      end do
      do s = 0, t - 1
         tmp = la(k, s)
         la(k, s) = la(t, s)
         la(t, s) = tmp
      end do

      lk = la(k, t)
      db = (d(t - 1) * d(k) + lk * lk) / d(t)
      do r = k + 1, m
         lr = la(r, k)
         la(r, k) = (d(k) * la(r, t) - lk * lr) / d(t)
         la(r, t) = (db * lr + lk * la(r, k)) / d(k)
      end do
      d(t) = db
   end subroutine swop_rows

   ! Read system matrix A and vector b interactively; returns .true. on error
   logical function inpsys()
      integer(kind=int64) :: i, j, k, r, s
      logical :: sw
      character(len=256) :: g
      character(len=8) :: rstr

      sw = .false.
      do r = 0, n - 1
         write(rstr, '(I0)') r + 1
         write(*, '(4A)', advance='no') &
               ' row A', trim(rstr), ' and b', trim(rstr)
         write(*, '(A)', advance='no') ' '
         read(*, '(A)') g
         write(*, '()')

         if (instr_any(g, '\./') /= 0) sw = .true.

         ! Parse space/pipe-delimited numbers into row r of a()
         k = len_trim(g)
         i = 1
         do s = 0, m
            do while (i <= k .and. index(' |', g(i:i)) /= 0)
               i = i + 1
            end do
            j = i
            do while (i <= k .and. index(' |', g(i:i)) == 0)
               i = i + 1
            end do
            if (j < i) a(s, m1 + r) = val_d(g(j:i - 1))
         end do
         write(*, '()')
      end do

      if (sw) write(*, '(A)') 'illegal input'
      inpsys = sw
   end function inpsys

   ! Read complex base c = x+yi, fill powers into a()
   subroutine inpconst(pr)
      integer(kind=int64), intent(in) :: pr
      integer(kind=int64) :: r, m2, rpos
      real(kind=real64) :: p, q, t_val, x, y
      character(len=256) :: g
      character(len=64) :: line

      m2 = m1 + 1
      q = 0.0d0

      write(*, '(A)', advance='no') ' a + bi:'
      read(*, '(A)') g
      write(*, '()')
      g = trim(g) // ' + '
      rpos = index(g, '+')
      x = val_d(g(1:rpos - 1))
      y = val_d(g(rpos + 1:))

      if (y /= 0.0d0) then
         write(line, '(G0,A,G0,A)') x, ' +', y, '*i'
      else
         write(line, '(G0)') x
      end if
      write(*, '(A)') trim(line)

      a(0, m1) = 1.0d0
      p = 10.0d0**pr
      a(1, m1) = p
      do r = 2, m - 1
         t_val = p
         p = p * x - q * y
         q = t_val * y + q * x
         a(r, m1) = floor(p + 0.5d0, kind=8)
         a(r, m2) = floor(q + 0.5d0, kind=8)
      end do
   end subroutine inpconst

   ! Compute max digit-count per column across all rows
   subroutine col_widths(p_arr)
      integer(kind=int64), intent(out) :: p_arr(0:mn)
      integer(kind=int64) :: r, s
      do s = 0, mn
         p_arr(s) = 1
         do r = 0, m
            if (dlen(a(r, s)) > p_arr(s)) p_arr(s) = dlen(a(r, s))
         end do
      end do
   end subroutine col_widths

   ! Print the working matrix; sw=0 for initial, sw/=0 for final output
   subroutine prntm(sw)
      integer(kind=int64), intent(in) :: sw
      integer(kind=int64), allocatable :: p_arr(:)
      integer(kind=int64) :: k, r, s
      character(len=32) :: g
      real(kind=real64) :: q
      logical :: ok, trivial

      allocate(p_arr(0:mn))
      call col_widths(p_arr)

      if (sw /= 0) then
         write(*, '(A)') 'P | Hnf'

         ! Find first non-zero row in last column
         k = 0
         do r = 0, m
            if (a(r, mn) /= 0.0d0) then
               k = r
               exit
            end if
         end do

         ok = (a(k, mn) == 1.0d0)
         do s = m1, mn - 1
            ok = ok .and. (a(k, s) == 0.0d0)
         end do
         if (ok) then
            g = '  -solution'
         else
            g = '   inconsistent'
         end if

         trivial = ok
         do s = 0, m - 1
            trivial = trivial .and. (a(k, s) == 0.0d0)
         end do
         if (trivial) g = ''

         ! HNF and solution rows
         do r = m, k, -1
            if (r == k) then
               write(*, '(A,A)') trim(row_str(r, p_arr)), trim(g)
            else
               write(*, '(A)') trim(row_str(r, p_arr))
            end if
         end do

         ! Null-space rows with squared lengths
         do r = 0, k - 1
            q = 0.0d0
            do s = 0, m - 1
               q = q + a(r, s) * a(r, s)
            end do
            write(*, '(A,A,I0,A)') trim(row_str(r, p_arr)), '   (', nint(q, kind=8), ')'
         end do

      else !Pete commented out
         !      write(*, '(A)') 'I | Ab~'
         !      do r = 0, m
         !        write(*, '(A)') trim(row_str(r, p_arr))
         !      end do
      end if

      deallocate(p_arr)
   end subroutine prntm

   ! Main LLL algorithm driver
   subroutine main_sub(sw_in)
      integer(kind=int64), intent(in) :: sw_in
      integer(kind=int64) :: i, k, t, tl
      logical :: do_swap
      real(kind=real64) :: db, lk

      tl = 0

      if (sw_in /= 0) then
         call inpconst(sw_in)
      else
         if (inpsys()) return
      end if

      ! Augment with e_m and prefix standard basis
      a(m, mn) = 1.0d0
      do i = 0, m
         a(i, i) = 1.0d0
      end do
      ! Gram sub-determinants all 1
      do i = -1, m
         d(i) = 1.0d0
      end do

      if (echo_flag) call prntm(0_int64)

      k = 1
      do while (k <= m)
         t = k - 1
         call reduce_row(k, t)

         do_swap = (c1 == nx .and. c2 == nx)
         if (do_swap) then
            lk = la(k, t)
            db = d(t - 1) * d(k) + lk * lk
            ! Lovasz condition: Bk >= (alpha - mu_kt^2) * Bt
            do_swap = (db * ald < d(t) * d(t) * aln)
         end if

         if (do_swap .or. (c1 <= c2 .and. c1 < nx)) then
            call swop_rows(k)
            if (k > 1) k = k - 1
         else
            do i = t - 1, 0, -1
               call reduce_row(k, i)
            end do
            k = k + 1
         end if

         tl = tl + 1
      end do

      call prntm(-1_int64)
      write(*, '(A,I0)') 'loop ', tl
   end subroutine main_sub

end module dioph_mod

program diophantine
  use dioph_mod
   implicit none

   character(len=256) :: g
   integer(kind=int64) :: i, sw, ios

   do
      write(*, '()')
      sw = 0

      ! Read 'rows', skipping comment lines that start with '
      do
         write(*, '(A)', advance='no') ' rows '
         read(*, '(A)', iostat=ios) g
         write(*, '()')
         if (ios /= 0) stop
         if (index(g, "'") /= 0) then
            write(*, '(A)') trim(g)
            if (index(g, 'const') /= 0) sw = ior(sw, 1_int64)
         else
            exit
         end if
      end do

      n = int(val_d(g), kind=8)
      if (n < 1) exit

      write(*, '(A)', advance='no') ' cols '
      read(*, '(A)', iostat=ios) g
      write(*, '()')
      if (ios /= 0) stop
      m = int(val_d(g), kind=8)

      if (m < 1) then
         do i = 1, n
            read(*, '(A)', iostat=ios) g
            if (ios /= 0) stop
         end do
         cycle
      end if

      if (sw /= 0) then
         sw = n - 1
         n = 2
         m = m + 2
      end if

      m1 = m + 1
      mn = m1 + n
      nx = mn + 1

      if (allocated(la)) deallocate(la)
      if (allocated(d)) deallocate(d)
      if (allocated(a)) deallocate(a)

      allocate(la(0:m, 0:m))
      allocate(d(-1:m))
      allocate(a(0:m, 0:mn))
      la = 0.0d0
      d = 0.0d0
      a = 0.0d0

      call main_sub(sw)
      write(*, '()')
   end do

   if (allocated(la)) deallocate(la)
   if (allocated(d)) deallocate(d)
   if (allocated(a)) deallocate(a)

end program diophantine

