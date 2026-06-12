program main
implicit none
integer :: lun
character(len=256) :: line
integer :: ios
   open(file='unixdict.txt',newunit=lun)
   do
      read(lun,'(a)',iostat=ios)line
      if(ios /= 0)exit
      if( index(line,'the') /= 0 .and. len_trim(line) > 11 ) then
         write(*,'(a)')trim(line)
      endif
   enddo
end program main
