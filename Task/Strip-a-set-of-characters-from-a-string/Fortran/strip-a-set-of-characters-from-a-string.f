elemental subroutine strip(string,set)
  character(len=*), intent(inout) :: string
  character(len=*), intent(in)    :: set
  integer                         :: old, new, stride
  old = 1; new = 1
  do
    stride = scan( string( old : ), set )
    if ( stride > 0 ) then
      string( new : new+stride-2 ) = string( old : old+stride-2 )
      old = old+stride
      new = new+stride-1
    else
      string( new : ) = string( old : )
      return
    end if
  end do
end subroutine strip
