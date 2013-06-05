! count letters from stdin
program LetterFrequency
  implicit none
  character (len=1) :: s
  integer, dimension(26) :: a
  integer :: ios, i, t
  data a/26*0/,i/0/
  open(unit=7, file='/dev/stdin', access='direct', form='formatted', recl=1, status='old', iostat=ios)
  if (ios .ne. 0) then
    write(0,*)'Opening stdin failed'
    stop
  endif
  do i=1, huge(i)
    read(unit=7, rec = i, fmt = '(a)', iostat = ios ) s
    if (ios .ne. 0) then
      !write(0,*)'ios on failure is ',ios
      close(unit=7)
      exit
    endif
    t = ior(iachar(s(1:1)), 32) - iachar('a')
    if ((0 .le. t) .and. (t .le. iachar('z'))) then
      t = t+1
      a(t) = a(t) + 1
    endif
  end do
  write(6, *) a
end program LetterFrequency
