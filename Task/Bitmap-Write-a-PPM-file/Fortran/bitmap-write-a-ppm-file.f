module RCImageIO
  use RCImageBasic

  implicit none

contains

  subroutine output_ppm(u, img)
    integer, intent(in) :: u
    type(rgbimage), intent(in) :: img
    integer :: i, j

    write(u, '(A2)') 'P6'
    write(u, '(I0,'' '',I0)') img%width, img%height
    write(u, '(A)') '255'

    do j=1, img%height
       do i=1, img%width
          write(u, '(3A1)', advance='no') achar(img%red(i,j)), achar(img%green(i,j)), &
                                          achar(img%blue(i,j))
       end do
    end do

  end subroutine output_ppm

end module RCImageIO
