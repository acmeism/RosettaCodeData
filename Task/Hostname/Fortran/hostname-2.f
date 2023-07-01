program test_hostname
   use, intrinsic  :: iso_c_binding
   implicit none
   interface !to function: int gethostname(char *name, size_t namelen);
      integer(c_int) function gethostname(name, namelen) bind(c)
         use, intrinsic  :: iso_c_binding, only: c_char, c_int, c_size_t
         integer(c_size_t), value, intent(in) :: namelen
         character(len=1,kind=c_char), dimension(namelen),  intent(inout) ::  name
      end function gethostname
   end interface
   integer(c_int) :: status
   integer,parameter :: HOST_NAME_MAX=255
   character(kind=c_char,len=1),dimension(HOST_NAME_MAX) :: cstr_hostname
   integer(c_size_t) :: lenstr
   character(len=:),allocatable :: hostname
   lenstr = HOST_NAME_MAX
   status = gethostname(cstr_hostname, lenstr)
   hostname = c_to_f_string(cstr_hostname)
   write(*,*) hostname, len(hostname)

 contains
   ! convert c_string to f_string
   pure function c_to_f_string(c_string) result(f_string)
      use, intrinsic :: iso_c_binding, only: c_char, c_null_char
      character(kind=c_char,len=1), intent(in) :: c_string(:)
      character(len=:), allocatable :: f_string
      integer i, n
      i = 1
      do
         if (c_string(i) == c_null_char) exit
         i = i + 1
      end do
      n = i - 1  ! exclude c_null_char
      allocate(character(len=n) :: f_string)
      f_string = transfer(c_string(1:n), f_string)
   end function c_to_f_string

end program test_hostname
