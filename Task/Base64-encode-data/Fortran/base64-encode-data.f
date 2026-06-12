program demo_base64
! base64-encode data to RFC-4648 and print to standard output
! usage: base64 inputfile > outputfile
use,intrinsic :: iso_fortran_env, only: stderr=>ERROR_UNIT, stdout=>OUTPUT_UNIT
use,intrinsic :: iso_fortran_env, only : int32
implicit none
integer(kind=int32)          :: i, j, column, sz, pad, iostat
character(len=1),allocatable :: text(:)
character(len=:),allocatable :: infile
character(len=4)             :: chunk
integer,parameter            :: rfc4648_linelength=76
character(len=1),parameter   :: rfc4648_padding='='
   infile=get_arg(1)
   ! allocate array and copy file into it and pad with two characters at end
   call slurp(infile,text)
   ! figure out how many characters at end are pad characters
   sz=size(text)-2
   pad=3-mod(sz,3)
   column=0
   ! place three bytes and zero into 32bit integer
   ! take sets of 6 bits from integer and place into every 8 bits
   do i=1,sz,3
      chunk=three2four(text(i:i+2))
      if(i.gt.sz-3)then ! if at end put any pad characters in place
         if(pad.gt.0.and.pad.lt.3)then
            chunk(5-pad:)=repeat(rfc4648_padding,pad)
         endif
      endif
      if(column.ge.rfc4648_linelength)then
         write(stdout,'(a)')
         flush(unit=stdout,iostat=iostat)
         column=0
      endif
      write(stdout,'(a)',advance='no')chunk
      column=column+4
   enddo
   if(column.ne.0)write(stdout,'(a)')
contains

function three2four(tri) result(quad)
character(len=1),intent(in) :: tri(3)
character(len=4)            :: quad
integer(kind=int32)         :: i32, i, j, k, iout(4)
character(len=*),parameter  :: rfc4648_alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
   i32 = transfer([(tri(j),j=3,1,-1),achar(0)], i32 )
   iout = 0
   ! The bits are numbered 0 to BIT_SIZE(I)-1, from right to left.
   do j=0,3
      call  mvbits(i32, (j)*6, 6, iout(4-j), 0)
      k=4-j
      quad(k:k)=rfc4648_alphabet(iout(k)+1:iout(k)+1)
   enddo
end function three2four

function get_arg(iarg) result(value)
! get nth argument from command line
integer,intent(in)           :: iarg
character(len=:),allocatable :: value
integer                      :: argument_length, istat
   call get_command_argument(number=iarg,length=argument_length)
   if(allocated(value))deallocate(value)
   allocate(character(len=argument_length) :: value)
   value(:)=''
   call get_command_argument(iarg, value, status=istat)
end function get_arg

subroutine slurp(filename,text)
! allocate text array and read file filename into it, padding on two characters
character(len=*),intent(in)              :: filename
character(len=1),allocatable,intent(out) :: text(:)
integer            :: nchars=0, igetunit, iostat=0, i
character(len=256) :: iomsg
character(len=1)   :: byte
   open(newunit=igetunit, file=trim(filename), action="read", iomsg=iomsg,&
   &form="unformatted", access="stream",status='old',iostat=iostat)
   if(iostat /= 0) stop '<ERROR> *slurp* '//trim(iomsg)
   inquire(unit=igetunit, size=nchars)
   if(nchars <= 0)then
      write(stderr,'(a)')'*slurp* empty file '//trim(filename)
      return
   endif
   allocate( text(nchars+2) )             ! storage holds file and two padding characters
   read(igetunit,iostat=iostat,iomsg=iomsg) text(:nchars) ! load input file -> text array
   if(iostat /= 0) stop '*slurp* bad read of '//trim(filename)//':'//trim(iomsg)
   text(size(text)-1:)=repeat(achar(0),2) ! init padding characters
   close(iostat=iostat,unit=igetunit)     ! close if opened successfully or not
end subroutine slurp

end program demo_base64
