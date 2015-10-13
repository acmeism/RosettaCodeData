program main

 character(len=:),allocatable :: str

 str = 'hello'
 str = str//' world'

 write(*,*) str

end program main
