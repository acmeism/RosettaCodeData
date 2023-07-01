module handlers_m
  use iso_c_binding
  use gtk
  implicit none

 contains

   subroutine destroy (widget, gdata) bind(c)
    type(c_ptr), value :: widget, gdata
    call gtk_main_quit ()
  end subroutine destroy

end module handlers_m

program test
  use iso_c_binding
  use gtk
  use handlers_m
  implicit none

  type(c_ptr) :: window
  type(c_ptr) :: box
  type(c_ptr) :: button

  call gtk_init ()
  window = gtk_window_new (GTK_WINDOW_TOPLEVEL)
  call gtk_window_set_default_size(window, 500, 20)
  call gtk_window_set_title(window, "gtk-fortran"//c_null_char)
  call g_signal_connect (window, "destroy"//c_null_char, c_funloc(destroy))
  box = gtk_hbox_new (TRUE, 10_c_int);
  call gtk_container_add (window, box)
  button = gtk_button_new_with_label ("Goodbye, World!"//c_null_char)
  call gtk_box_pack_start (box, button, FALSE, FALSE, 0_c_int)
  call g_signal_connect (button, "clicked"//c_null_char, c_funloc(destroy))
  call gtk_widget_show (button)
  call gtk_widget_show (box)
  call gtk_widget_show (window)
  call gtk_main ()

end program test
