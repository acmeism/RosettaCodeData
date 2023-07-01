#include <QApplication>
#include "task.h"

int main( int argc, char *argv[ ] ) {
   QApplication app( argc , argv ) ;
   MyWidget theWidget ;
   theWidget.show( ) ;
   return app.exec( ) ;
}
