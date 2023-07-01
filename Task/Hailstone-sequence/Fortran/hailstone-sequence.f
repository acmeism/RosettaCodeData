program Hailstone
  implicit none

  integer :: i, maxn
  integer :: maxseqlen = 0, seqlen
  integer, allocatable :: seq(:)

  call hs(27, seqlen)
  allocate(seq(seqlen))
  call hs(27, seqlen, seq)
  write(*,"(a,i0,a)") "Hailstone sequence for 27 has ", seqlen, " elements"
  write(*,"(a,4(i0,a),3(i0,a),i0)") "Sequence = ", seq(1), ", ", seq(2), ", ", seq(3), ", ", seq(4), " ...., ",  &
                                     seq(seqlen-3), ", ", seq(seqlen-2), ", ", seq(seqlen-1), ", ", seq(seqlen)

  do i = 1, 99999
    call hs(i, seqlen)
    if (seqlen > maxseqlen) then
      maxseqlen = seqlen
      maxn = i
    end if
  end do
  write(*,*)
  write(*,"(a,i0,a,i0,a)") "Longest sequence under 100000 is for ", maxn, " with ", maxseqlen, " elements"

  deallocate(seq)

contains

subroutine hs(number, length, seqArray)
  integer, intent(in)  :: number
  integer, intent(out) :: length
  integer, optional, intent(inout) :: seqArray(:)
  integer :: n

  n = number
  length = 1
  if(present(seqArray)) seqArray(1) = n
  do while(n /= 1)
    if(mod(n,2) == 0) then
      n = n / 2
    else
      n = n * 3 + 1
    end if
    length = length + 1
    if(present(seqArray)) seqArray(length) = n
  end do
end subroutine

end program
