program substring

  character(len=5) :: string
  string = "Hello"

  write (*,*) string
  write (*,*) string(2:)
  write (*,*) string( :len(string)-1)
  write (*,*) string(2:len(string)-1)

end program substring
