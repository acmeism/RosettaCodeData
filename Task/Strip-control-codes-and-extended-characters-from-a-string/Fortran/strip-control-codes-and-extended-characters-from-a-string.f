module stripcharacters
implicit none

contains

  pure logical function not_control(ch)
    character, intent(in) :: ch
    not_control = iachar(ch) >= 32 .and. iachar(ch) /= 127
  end function not_control

  pure logical function not_extended(ch)
    character, intent(in) :: ch
    not_extended = iachar(ch) >= 32 .and. iachar(ch) < 127
  end function not_extended

  pure function strip(string,accept) result(str)
    character(len=*), intent(in) :: string
    character(len=len(string))   :: str
    interface
      pure logical function accept(ch)
        character, intent(in) :: ch
      end function except
    end interface
    integer :: i,n
    str = repeat(' ',len(string))
    n = 0
    do i=1,len(string)
      if ( accept(string(i:i)) ) then
        n = n+1
        str(n:n) = string(i:i)
      end if
    end do
  end function strip

end module stripcharacters


program test
  use stripcharacters

  character(len=256) :: string, str
  integer            :: ascii(256), i
  forall (i=0:255) ascii(i) = i
  forall (i=1:len(string)) string(i:i) = achar(ascii(i))
  write (*,*) string

  write (*,*) 'Control characters deleted:'
  str = strip(string,not_control)
  write (*,*) str

  forall (i=1:len(string)) string(i:i) = achar(ascii(i))
  write (*,*) 'Extended characters deleted:'
  write (*,*) strip(string,not_extended)
end program test
