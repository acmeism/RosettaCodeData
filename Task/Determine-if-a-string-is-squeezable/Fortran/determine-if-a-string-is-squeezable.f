program main
implicit none
character(len=:),allocatable :: strings(:)

strings=[ character(len=72) :: &
'', &
'"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln',  &
'..1111111111111111111111111111111111111111111111111111111111111117777888', &
'I never give ''em hell, I just tell the truth, and they think it''s hell.',&
'                                                    --- Harry S Truman'    &
]

   call printme( trim(strings(1)), ' ' )
   call printme( strings(2:4),     ['-','7','.'] )
   call printme( strings(5),       [' ','-','r'] )

contains

impure elemental subroutine printme(str,chr)
character(len=*),intent(in) :: str
character(len=1),intent(in) :: chr
character(len=:),allocatable :: answer
   write(*,'(a)')repeat('=',9)
   write(*,'("IN:   <<<",g0,">>>")')str
   answer=compact(str,chr)
   write(*,'("OUT:  <<<",g0,">>>")')answer
   write(*,'("LENS: ",*(g0,1x))')"from",len(str),"to",len(answer),"for a change of",len(str)-len(answer)
   write(*,'("CHAR: ",g0)')chr
end subroutine printme

elemental function compact(str,charp) result (outstr)

character(len=*),intent(in)  :: str
character(len=1),intent(in)  :: charp
character(len=:),allocatable :: outstr
character(len=1)             :: ch, last_one
integer                      :: i, pio ! position in output

   outstr=repeat(' ',len(str))      ! start with a string big enough to hold any output
   if(len(outstr)==0)return         ! handle edge condition
   last_one=str(1:1)                ! since at least this long start output with first character
   outstr(1:1)=last_one
   pio=1

   do i=2,len(str)
      ch=str(i:i)
      pio=pio+merge(0,1, ch.eq.last_one.and.ch.eq.charp) ! decide whether to advance before saving
      outstr(pio:pio)=ch  ! store new one or overlay the duplcation
      last_one=ch
   enddo

   outstr=outstr(:pio)              ! trim the output string to just what was set
end function compact

end program main
}
