!-----------------------------------------------------------------------
!module dll_module
!-----------------------------------------------------------------------
module dll_module
   use iso_c_binding
   implicit none
   private ! all by default
   public :: os_type, dll_type, load_dll, free_dll, init_os_type, init_dll
   ! general constants:
   ! the number of bits in an address (32-bit or 64-bit).
   integer, parameter :: bits_in_addr = c_intptr_t*8
   ! global error-level variables:
   integer, parameter :: errid_none = 0
   integer, parameter :: errid_info = 1
   integer, parameter :: errid_warn = 2
   integer, parameter :: errid_severe = 3
   integer, parameter :: errid_fatal = 4

   integer :: os_id

   type os_type
      character(10) :: endian
      character(len=:), allocatable :: newline
      character(len=:), allocatable :: os_desc
      character(1) :: pathsep
      character(1) :: swchar
      character(11) :: unfform
   end type os_type

   type dll_type
      integer(c_intptr_t) :: fileaddr
      type(c_ptr) :: fileaddrx
      type(c_funptr) :: procaddr
      character(1024) :: filename
      character(1024) :: procname
   end type dll_type

   ! interface to linux API
   interface
      function dlopen(filename,mode) bind(c,name="dlopen")
         ! void *dlopen(const char *filename, int mode);
         use iso_c_binding
         implicit none
         type(c_ptr) :: dlopen
         character(c_char), intent(in) :: filename(*)
         integer(c_int), value :: mode
      end function

      function dlsym(handle,name) bind(c,name="dlsym")
         ! void *dlsym(void *handle, const char *name);
         use iso_c_binding
         implicit none
         type(c_funptr) :: dlsym
         type(c_ptr), value :: handle
         character(c_char), intent(in) :: name(*)
      end function

      function dlclose(handle) bind(c,name="dlclose")
         ! int dlclose(void *handle);
         use iso_c_binding
         implicit none
         integer(c_int) :: dlclose
         type(c_ptr), value :: handle
      end function
   end interface

contains


   !-----------------------------------------------------------------------
   !Subroutine init_dll
   !-----------------------------------------------------------------------
   subroutine init_dll(dll)
      implicit none
      type(dll_type), intent(inout) :: dll
      dll % fileaddr = 0
      dll % fileaddrx = c_null_ptr
      dll % procaddr = c_null_funptr
      dll % filename = " "
      dll % procname = " "
   end subroutine init_dll

   !-----------------------------------------------------------------------
   !Subroutine init_os_type
   !-----------------------------------------------------------------------
   subroutine init_os_type(os_id,os)
      implicit none
      integer, intent(in) :: os_id
      type(os_type), intent(inout) :: os

      select case (os_id)
       case (1) ! Linux

         os % endian = 'big_endian'
         os % newline = achar(10)
         os % os_desc = 'Linux'
         os % pathsep = '/'
         os % swchar = '-'
         os % unfform = 'unformatted'

       case (2) ! MacOS

         os % endian = 'big_endian'
         os % newline = achar(10)
         os % os_desc = 'MacOS'
         os % pathsep = '/'
         os % swchar = '-'
         os % unfform = 'unformatted'

       case default

      end select

   end subroutine init_os_type

   !-----------------------------------------------------------------------
   !Subroutine load_dll
   !-----------------------------------------------------------------------
   subroutine load_dll (os, dll, errstat, errmsg )
      ! this subroutine is used to dynamically load a dll.


      type (os_type), intent(in) :: os
      type (dll_type), intent(inout) :: dll
      integer, intent( out) :: errstat
      character(*), intent( out) :: errmsg

      integer(c_int), parameter :: rtld_lazy=1
      integer(c_int), parameter :: rtld_now=2
      integer(c_int), parameter :: rtld_global=256
      integer(c_int), parameter :: rtld_local=0

      errstat = errid_none
      errmsg = ''

      select case (os%os_desc)
       case ("Linux","MacOS")
         ! load the dll and get the file address:
         dll%fileaddrx = dlopen( trim(dll%filename)//c_null_char, rtld_lazy )
         if( .not. c_associated(dll%fileaddrx) ) then
            errstat = errid_fatal
            write(errmsg,'(i2)') bits_in_addr
            errmsg = 'the dynamic library '//trim(dll%filename)//' could not be loaded. check that the file '// &
            'exists in the specified location and that it is compiled for '//trim(errmsg)//'-bit systems.'
            return
         end if

         ! get the procedure address:
         dll%procaddr = dlsym( dll%fileaddrx, trim(dll%procname)//c_null_char )
         if(.not. c_associated(dll%procaddr)) then
            errstat = errid_fatal
            errmsg = 'the procedure '//trim(dll%procname)//' in file '//trim(dll%filename)//' could not be loaded.'
            return
         end if

       case ("Windows")
         errstat = errid_fatal
         errmsg = ' load_dll not implemented for '//trim(os%os_desc)

       case default
         errstat = errid_fatal
         errmsg = ' load_dll not implemented for '//trim(os%os_desc)
      end select
      return
   end subroutine load_dll

   !-----------------------------------------------------------------------
   !Subroutine free_dll
   !-----------------------------------------------------------------------
   subroutine free_dll (os, dll, errstat, errmsg )

      ! this subroutine is used to free a dynamically loaded dll
      type (os_type), intent(in) :: os
      type (dll_type), intent(inout) :: dll
      integer, intent( out) :: errstat
      character(*), intent( out) :: errmsg

      integer(c_int) :: success

      errstat = errid_none
      errmsg = ''

      select case (os%os_desc)
       case ("Linux","MacOS")

         ! close the library:
         success = dlclose( dll%fileaddrx )
         if ( success /= 0 ) then
            errstat = errid_fatal
            errmsg = 'the dynamic library could not be freed.'
            return
         else
            errstat = errid_none
            errmsg = ''
         end if

       case ("Windows")

         errstat = errid_fatal
         errmsg = ' free_dll not implemented for '//trim(os%os_desc)

       case default
         errstat = errid_fatal
         errmsg = ' free_dll not implemented for '//trim(os%os_desc)
      end select

      return
   end subroutine free_dll
end module dll_module



!-----------------------------------------------------------------------
!Main program
!-----------------------------------------------------------------------
program test_load_dll
   use, intrinsic :: iso_c_binding
   use dll_module
   implicit none

   ! interface to our shared lib
   abstract interface
      function add_n(a,b)
         use, intrinsic :: iso_c_binding
         implicit none
         real(c_double), intent(in) :: a,b
         real(c_double) :: add_n
      end function add_n
   end interface

   type(os_type) :: os
   type(dll_type) :: dll
   integer :: errstat
   character(1024) :: errmsg
   type(c_funptr) :: cfun
   procedure(add_n), pointer :: fproc

   call init_os_type(1,os)
   call init_dll(dll)

   dll%filename="/full_path_to/shared_lib/shared_lib_new.so"
   ! name of the procedure in shared_lib
   ! c version of the function
   dll%procname="add_n"

   write(*,*) "address: ", dll%procaddr

   call load_dll(os, dll, errstat, errmsg )
   write(*,*)"load_dll: errstat=", errstat
   write(*,*) "address: ", dll%procaddr

   call c_f_procpointer(dll%procaddr,fproc)

   write(*,*) "add_n(2,5)=",fproc(2.d0,5.d0)

   call free_dll (os, dll, errstat, errmsg )
   write(*,*)"free_dll: errstat=", errstat

   ! fortran version
   dll%procname="add_nf"

   call load_dll(os, dll, errstat, errmsg )
   write(*,*)"load_dll: errstat=", errstat
   write(*,*) "address: ", dll%procaddr

   call c_f_procpointer(dll%procaddr,fproc)

   write(*,*) "add_nf(2,5)=",fproc(2.d0,5.d0)

   call free_dll (os, dll, errstat, errmsg )
   write(*,*)"free_dll: errstat=", errstat


end program test_load_dll
