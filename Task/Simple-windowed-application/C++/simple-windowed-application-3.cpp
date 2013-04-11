#include <QApplication>
#include "clickcounter.h"

int main( int argc , char *argv[ ] ) {
   QApplication app( argc , argv ) ;
   Counter counter ;
   counter.show( ) ;
   return app.exec( ) ;
}
