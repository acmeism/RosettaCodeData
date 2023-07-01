program str_append
    implicit none

    character(len=20) :: str

    str= 'String'
    str(len_trim(str)+1:) = 'Append'
    print *, str

end program str_append
