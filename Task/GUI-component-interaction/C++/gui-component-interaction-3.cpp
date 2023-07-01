#include <QApplication>
#include "interaction.h"

int main( int argc , char *argv[ ] ) {
   QApplication app( argc, argv ) ;
   MyWidget theWidget ;
   theWidget.show( ) ;
   return app.exec( ) ;
}
