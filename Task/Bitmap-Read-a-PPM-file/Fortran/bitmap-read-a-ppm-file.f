subroutine read_ppm(u, img)
  integer, intent(in) :: u
  type(rgbimage), intent(out) :: img
  integer :: i, j, ncol, cc
  character(2) :: sign
  character :: ccode

  img%width = 0
  img%height = 0
  nullify(img%red)
  nullify(img%green)
  nullify(img%blue)

  read(u, '(A2)') sign
  read(u, *) img%width, img%height
  read(u, *) ncol

  write(0,*) sign
  write(0,*) img%width, img%height
  write(0,*) ncol

  if ( ncol /= 255 ) return

  call alloc_img(img, img%width, img%height)

  if ( valid_image(img) ) then
     do j=1, img%height
        do i=1, img%width
           read(u, '(A1)', advance='no', iostat=status) ccode
           cc = iachar(ccode)
           img%red(i,j) = cc
           read(u, '(A1)', advance='no', iostat=status) ccode
           cc = iachar(ccode)
           img%green(i,j) = cc
           read(u, '(A1)', advance='no', iostat=status) ccode
           cc = iachar(ccode)
           img%blue(i,j) = cc
        end do
     end do
  end if

end subroutine read_ppm
