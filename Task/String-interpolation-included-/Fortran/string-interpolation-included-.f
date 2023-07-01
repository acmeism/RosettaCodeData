program interpolate

  write (*,*) trim(inter("Mary had a X lamb.","X","little"))

contains

  elemental function inter(string,place,ins) result(new)
    character(len=*), intent(in)                          :: string,place,ins
    character(len=len(string)+max(0,len(ins)-len(place))) :: new
    integer                                               :: idx
    idx = index(string,place)
    if ( idx == 0 ) then
      new = string
    else
      new = string(1:idx-1)//ins//string(idx+len(place):len(string))
    end if
  end function inter

end program interpolate
