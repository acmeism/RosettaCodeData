program demo_verify
implicit none
    call nodup('')
    call nodup('.')
    call nodup('abcABC')
    call nodup('XYZ ZYX')
    call nodup('1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ')
contains

subroutine nodup(str)
character(len=*),intent(in)  :: str
character(len=*),parameter   :: g='(*(g0))'
character(len=:),allocatable :: ch
integer                      :: where
integer                      :: i
   where=0
   ch=''

   do i=1,len(str)-1
      ch=str(i:i)
      where=index(str(i+1:),ch)
      if(where.ne.0)then
         where=where+i
         exit
      endif
   enddo

   if(where.eq.0)then
     write(*,g)'STR: "',str,'"',new_line('a'),'LEN: ',len(str),'. No duplicate characters found'
   else
     write(*,g)'STR: "',str,'"'
     write(*,'(a,a,t1,a,a)')repeat(' ',where+5),'^',repeat(' ',i+5),'^'
     write(*,g)'LEN: ',len(str), &
     & '. Duplicate chars. First duplicate at positions ',i,' and ',where, &
     & ' where a ','"'//str(where:where)//'"(hex:',hex(str(where:where)),') was found.'
   endif
   write(*,*)

end subroutine nodup

function hex(ch) result(hexstr)
character(len=1),intent(in) :: ch
character(len=:),allocatable :: hexstr
   hexstr=repeat(' ',100)
   write(hexstr,'(Z0)')ch
   hexstr=trim(hexstr)
end function hex

end program demo_verify
