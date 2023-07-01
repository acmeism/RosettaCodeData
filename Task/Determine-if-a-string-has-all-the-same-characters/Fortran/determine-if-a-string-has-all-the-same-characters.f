program demo_verify
implicit none
    call homogeneous('')
    call homogeneous('2')
    call homogeneous('333')
    call homogeneous('.55')
    call homogeneous('tttTTT')
    call homogeneous('4444  444k')
contains

subroutine homogeneous(str)
character(len=*),intent(in)  :: str
character(len=:),allocatable :: ch
character(len=*),parameter   :: g='(*(g0))'
integer :: where
   if(len(str)>0)then;ch=str(1:1);else;ch='';endif
   where=verify(str,ch)
   if(where.eq.0)then
     write(*,g)'STR: "',str,'" LEN: ',len(str),'. All chars are a ','"'//ch//'"'
   else
     write(*,g)'STR: "',str,'" LEN: ',len(str), &
     & '. Multiple chars found. First difference at position ',where, &
     & ' where a ','"'//str(where:where)//'"(hex:',hex(str(where:where)),') was found.'
     write(*,g)repeat(' ',where+5),'^'
   endif
end subroutine homogeneous

function hex(ch) result(hexstr)
character(len=1),intent(in) :: ch
character(len=:),allocatable :: hexstr
   hexstr=repeat(' ',100)
   write(hexstr,'(Z0)')ch
   hexstr=trim(hexstr)
end function hex

end program demo_verify
