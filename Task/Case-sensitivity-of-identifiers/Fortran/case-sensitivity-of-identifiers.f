program Example
  implicit none

  character(8) :: dog, Dog, DOG

  dog = "Benjamin"
  Dog = "Samba"
  DOG = "Bernie"

  if (dog == DOG) then
    write(*,*) "There is just one dog named ", dog
  else
    write(*,*) "The three dogs are named ", dog, Dog, " and ", DOG
  end if

end program Example
