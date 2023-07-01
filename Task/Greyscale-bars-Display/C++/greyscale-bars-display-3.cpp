#include <QApplication>
#include "greytones.h"

int main( int argc, char * argv[ ] ) {
   QApplication app( argc , argv ) ;
   MyWidget window ;
   window.setWindowTitle( QApplication::translate( "greyScales" , "grey scales demonstration" ) ) ;
   window.show( ) ;
   return app.exec( ) ;
}
