type(scimage) :: gray
type(rgbimage) :: animage
  ! ... here we "load" or create animage
  ! while gray must be created or initialized to null
  ! or errors can arise...
  call init_img(gray)
  gray = animage
  animage = gray
  call output_ppm(an_unit, animage)
