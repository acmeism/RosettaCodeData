module anim

  type animal
  end type animal

  type, extends(animal) :: dog
  end type dog

  type, extends(animal) :: cat
  end type cat

  type, extends(dog) :: lab
  end type lab

  type, extends(dog) :: collie
  end type collie

end module anim
