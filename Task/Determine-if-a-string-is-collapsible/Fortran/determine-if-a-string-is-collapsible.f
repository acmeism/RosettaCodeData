!
! Determine if a string is collapsible
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
 program CollapsibleStrings

implicit none

character (len=*), parameter :: s1=''
character (len=*), parameter :: s2='"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln '
character (len=*), parameter :: s3='..1111111111111111111111111111111111111111111111111111111111111117777888'
character (len=*), parameter :: s4="I never give 'em hell, I just tell the truth, and they think it's hell. "
character (len=*), parameter :: s5='                                                   ---  Harry S Truman  '
character (len=*), parameter :: s6="The better the 4-wheel drive, the further you'll be from help when ya get stuck!"
character (len=*), parameter :: s7='headmistressship'
character (len=*), parameter :: s8='aardvark'


call checkCollapse (s1)
call checkCollapse (s2)
call checkCollapse (s3)
call checkCollapse (s4)
call checkCollapse (s5)
call checkCollapse (s6)
call checkCollapse (s7)
call checkCollapse (s8)


contains

subroutine checkCollapse (s)
character (len=*), intent(in) :: s
character (len=len(s)) :: sOut
integer ::  l, iLast,iNext,iOut

l = len(s)
! early return if s empty
if (l .eq. 0) then
  sOut = S
  iout = 0
else
  sOut(1:1) = s(1:1)
  iLast = 1
  iOut = 1
  do while (iLast .lt. len(s))                                            ! through entire input string
    iNext=iLast                                                           ! to find next letter .ne. last letter
    do while (iNext .le. len(s) .and. s(iNext:iNext) .eq. s(iLast:iLast))
      iNext = iNext + 1                                                   ! Skip this letter if it is the same as last
    enddo
    if (iNext .le. l) then
      iOut = iOut + 1                                                       ! 'next' is to copy to the end of sOut
      sOut(iOut:iOut) = s(iNext:iNext)
      iLast = iNext                                                         ! 'next' becomes the new Last
    else
      exit
    endif
  end do
endif
write (*, '("<<<",A,">>>", x, "(",i0,")")')  s (:l), l
write (*, '("<<<",A,">>>", x, "(",i0,")")')  sOut (:iOut), iOut

end subroutine checkCollapse
end program CollapsibleStrings
