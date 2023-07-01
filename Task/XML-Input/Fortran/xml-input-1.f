program tixi_rosetta
  use tixi
  implicit none
  integer :: i
  character (len=100) :: xml_file_name
  integer :: handle
  integer :: error	
  character(len=100) :: name, xml_attr
  xml_file_name = 'rosetta.xml'

  call tixi_open_document( xml_file_name, handle, error )
  i = 1
  do
      xml_attr = '/Students/Student['//int2char(i)//']'
      call tixi_get_text_attribute( handle, xml_attr,'Name', name, error )
      if(error /= 0) exit
      write(*,*) name
      i = i + 1
  enddo

  call tixi_close_document( handle, error )

  contains

  function int2char(i) result(res)
    character(:),allocatable :: res
    integer,intent(in) :: i
    character(range(i)+2) :: tmp
    write(tmp,'(i0)') i
    res = trim(tmp)
  end function int2char

end program tixi_rosetta
