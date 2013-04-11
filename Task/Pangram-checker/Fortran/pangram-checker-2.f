program test

  use pangram, only: is_pangram

  implicit none
  character (256) :: string

  string = 'This is a sentence.'
  write (*, '(a)') trim (string)
  write (*, '(l1)') is_pangram (string)
  string = 'The five boxing wizards jumped quickly.'
  write (*, '(a)') trim (string)
  write (*, '(l1)') is_pangram (string)

end program test
