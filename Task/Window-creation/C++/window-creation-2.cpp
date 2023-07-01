#include <iostream>
#include <gtkmm.h>

int
main( int argc, char* argv[] )
{
 try
 {
  Gtk::Main m( argc, argv ) ;
  Gtk::Window win ;
  m.run( win ) ;
 }

 catch( std::exception const & exc )
 {
  std::cout << exc.what() << std::endl ;
  exit( -1 ) ;
 }

 exit( 0 ) ;
}
