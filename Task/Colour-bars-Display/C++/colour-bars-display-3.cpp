#include <QApplication>
#include "colorbars.h"

int main( int argc, char * argv[ ] ) {
   QApplication app( argc , argv ) ;
   MyWidget window ;
   window.setWindowTitle( QApplication::translate( "colorslides" , "color slides demonstration" ) ) ;
   window.show( ) ;
   return app.exec( ) ;
}
