program notes
implicit none
integer                      :: i, length, iargs, lun, ios
integer,dimension(8)         :: values
character(len=:),allocatable :: arg
character(len=256)           :: line
character(len=1),parameter   :: tab=char(9)
   iargs = command_argument_count()
   open(file='notes.txt',newunit=lun,action='readwrite',position='append',status='unknown')
   if(iargs.eq.0)then
      rewind(lun)
      do
         read(lun,'(a)',iostat=ios)line
         if(ios.ne.0)exit
         write(*,'(a)')trim(line)
      enddo
   else
      call date_and_time(VALUES=values)
      write(lun,'(*(g0))')values(1),"-",values(2),"-",values(3),"T",values(5),":",values(6),":",values(7)
      write(lun,'(a)',advance='no')tab
      do i=1,iargs
         call get_command_argument(number=i,length=length)
         arg=repeat(' ',length)
         call get_command_argument(i, arg)
         write(lun,'(a,1x)',advance='no')arg
      enddo
      write(lun,*)
   endif
end program notes
