subroutine alloc_img_sc(img, w, h)
  type(scimage) :: img
  integer, intent(in) :: w, h

  allocate(img%channel(w, h))
  img%width = w
  img%height = h
end subroutine alloc_img_sc

subroutine free_img_sc(img)
  type(scimage) :: img

  if ( associated(img%channel) ) deallocate(img%channel)
end subroutine free_img_sc

subroutine rgbtosc(sc, colored)
  type(rgbimage), intent(in) :: colored
  type(scimage), intent(inout) :: sc

  if ( ( .not. valid_image(sc) ) .and. valid_image(colored) ) then
     call alloc_img(sc, colored%width, colored%height)
  end if

  if ( valid_image(sc) .and. valid_image(colored) ) then
     sc%channel = floor(0.2126*colored%red + 0.7152*colored%green + &
                        0.0722*colored%blue)
  end if

end subroutine rgbtosc

subroutine sctorgb(colored, sc)
  type(scimage), intent(in) :: sc
  type(rgbimage), intent(inout) :: colored

  if ( ( .not. valid_image(colored) ) .and. valid_image(sc) ) then
     call alloc_img_rgb(colored, sc%width, sc%height)
  end if

  if ( valid_image(sc) .and. valid_image(colored) ) then
     colored%red = sc%channel
     colored%green = sc%channel
     colored%blue = sc%channel
  end if

end subroutine sctorgb
