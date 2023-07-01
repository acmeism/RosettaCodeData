subroutine cullSieveBuffer(lwi, size, bpa, sba)

    implicit none
    integer, intent(in) :: lwi, size
    byte, intent(in) :: bpa(0:size - 1)
    byte, intent(out) :: sba(0:size - 1)
    integer :: i_limit, i_bitlmt, i_bplmt, i, sqri, bp, si, olmt, msk, j
    byte, dimension (0:7) :: bits
    common /twiddling/ bits

    i_bitlmt = size * 8 - 1
    i_limit = lwi + i_bitlmt
    i_bplmt = size / 4
    sba = 0
    i = 0
    sqri = (i + i) * (i + 3) + 3
    do while (sqri <= i_limit)
      if (iand(int(bpa(shiftr(i, 3))), shiftl(1, iand(i, 7))) == 0) then
        ! start index address calculation...
        bp = i + i + 3
        if (lwi <= sqri) then
          si = sqri - lwi
        else
          si = mod((lwi - sqri), bp)
          if (si /= 0) si = bp - si
        end if
        if (bp <= i_bplmt) then
          olmt = min(i_bitlmt, si + bp * 8 - 1)
          do while (si <= olmt)
            msk = bits(iand(si, 7))
            do j = shiftr(si, 3), size - 1, bp
              sba(j) = ior(int(sba(j)), msk)
            end do
            si = si + bp
          end do
        else
          do while (si <= i_bitlmt)
            j = shiftr(si, 3)
            sba(j) = ior(sba(j), bits(iand(si, 7)))
            si = si + bp
          end do
        end if
      end if
      i = i + 1
      sqri = (i + i) * (i + 3) + 3
    end do

  end subroutine cullSieveBuffer

  integer function countSieveBuffer(lmti, almti, sba)

    implicit none
    integer, intent(in) :: lmti, almti
    byte, intent(in) :: sba(0:almti)
    integer :: bmsk, lsti, i, cnt
    byte, dimension (0:65535) :: clut
    common /counting/ clut

    cnt = 0
    bmsk = iand(shiftl(-2, iand(lmti, 15)), 65535)
    lsti = iand(shiftr(lmti, 3), -2)
    do i = 0, lsti - 1, 2
      cnt = cnt + clut(shiftl(iand(int(sba(i)), 255), 8) + iand(int(sba(i + 1)), 255))
    end do
    countSieveBuffer = cnt + clut(ior(shiftl(iand(int(sba(lsti)), 255), 8) + iand(int(sba(lsti + 1)), 255), bmsk))

  end function countSieveBuffer

  program sieve_paged

    use OMP_LIB
    implicit none
    integer, parameter :: i_max = 1000000000, i_range = (i_max - 3) / 2
    integer, parameter :: i_l1cache_size = 16384, i_l1cache_bitsz = i_l1cache_size * 8
    integer, parameter :: i_l2cache_size = i_l1cache_size * 8, i_l2cache_bitsz = i_l2cache_size * 8
    integer :: cr, c0, c1, i, j, k, cnt
    integer, save :: scnt
    integer :: countSieveBuffer
    integer :: numthrds
    byte, dimension (0:i_l1cache_size - 1) :: bpa
    byte, save, allocatable, dimension (:) :: sba
    byte, dimension (0:7) :: bits = (/ 1, 2, 4, 8, 16, 32, 64, -128 /)
    byte, dimension (0:65535) :: clut
    common /twiddling/ bits
    common /counting/ clut

    type heaparr
      byte, allocatable, dimension(:) :: thrdsba
    end type heaparr
    type(heaparr), allocatable, dimension (:) :: sbaa

    !$OMP THREADPRIVATE(scnt, sba)

    numthrds = 1
    !$ numthrds = OMP_get_max_threads()
    allocate(sbaa(0:numthrds - 1))
    do i = 0, numthrds - 1
      allocate(sbaa(i)%thrdsba(0:i_l2cache_size - 1))
    end do

    CALL SYSTEM_CLOCK(count_rate=cr)
    CALL SYSTEM_CLOCK(c0)
    do k = 0, 65535 ! initialize counting Look Up Table
      j = k
      i = 16
      do while (j > 0)
        i = i - 1
        j = iand(j, j - 1)
      end do
      clut(k) = i
    end do
    bpa = 0 ! pre-initialization not guaranteed!
    call cullSieveBuffer(0, i_l1cache_size, bpa, bpa)

    cnt = 1
    !$OMP PARALLEL DO ORDERED
      do i = i_l2cache_bitsz, i_range, i_l2cache_bitsz * 8
        scnt = 0
        sba = sbaa(mod(i, numthrds))%thrdsba
        do j = i, min(i_range, i + 8 * i_l2cache_bitsz - 1), i_l2cache_bitsz
          call cullSieveBuffer(j - i_l2cache_bitsz, i_l2cache_size, bpa, sba)
          scnt = scnt + countSieveBuffer(i_l2cache_bitsz - 1, i_l2cache_size, sba)
        end do
        !$OMP ATOMIC
          cnt = cnt + scnt
      end do
    !$OMP END PARALLEL DO

    j = i_range / i_l2cache_bitsz * i_l2cache_bitsz
    k = i_range - j
    if (k /= i_l2cache_bitsz - 1) then
      call cullSieveBuffer(j, i_l2cache_size, bpa, sbaa(0)%thrdsba)
      cnt = cnt + countSieveBuffer(k, i_l2cache_size, sbaa(0)%thrdsba)
    end if
  !  write (*, '(i0, 1x)', advance = 'no') 2
  !  do i = 0, i_range
  !    if (iand(sba(shiftr(i, 3)), bits(iand(i, 7))) == 0) write (*, '(i0, 1x)', advance='no') (i + i + 3)
  !  end do
  !  write (*, *)
    CALL SYSTEM_CLOCK(c1)
    print '(a, i0, a, i0, a, f0.0, a)', 'Found ', cnt, ' primes up to ', i_max, &
          ' in ', ((c1 - c0) / real(cr) * 1000), ' milliseconds.'

    do i = 0, numthrds - 1
      deallocate(sbaa(i)%thrdsba)
    end do
    deallocate(sbaa)

  end program sieve_paged
