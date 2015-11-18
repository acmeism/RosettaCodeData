program json_fortran
   use json_module
   implicit none

   type phonebook_type
      character(len=:),allocatable :: name
      character(len=:),allocatable :: phone
   end type phonebook_type

   type(phonebook_type), dimension(3) :: PhoneBook
   integer :: i
   type(json_value),pointer :: json_phonebook,p,e
   type(json_file) :: json

   PhoneBook(1) % name = 'Adam'
   PhoneBook(2) % name = 'Eve'
   PhoneBook(3) % name = 'Julia'
   PhoneBook(1) % phone = '0000001'
   PhoneBook(2) % phone = '0000002'
   PhoneBook(3) % phone = '6666666'

   call json_initialize()

   !create the root structure:
   call json_create_object(json_phonebook,'')

   !create and populate the phonebook array:
   call json_create_array(p,'PhoneBook')
   do i=1,3
      call json_create_object(e,'')
      call json_add(e,'name',PhoneBook(i)%name)
      call json_add(e,'phone',PhoneBook(i)%phone)
      call json_add(p,e) !add this element to array
      nullify(e) !cleanup for next loop
   end do
   call json_add(json_phonebook,p) !add p to json_phonebook
   nullify(p) !no longer need this

   !write it to a file:
   call json_print(json_phonebook,'phonebook.json')

   ! read directly from a character string
   call json%load_from_string('{ "PhoneBook": [ { "name": "Adam", "phone": "0000001" },&
   { "name": "Eve", "phone": "0000002" }, { "name": "Julia", "phone": "6666666" } ]}')
   ! print it to the console
   call json%print_file()

end program json_fortran
