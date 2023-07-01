#include <QApplication>
#include "task.h"

int main( int argc , char *argv[ ] ) {
   QApplication app( argc , argv ) ;
   EntryWidget theWidget ;
   theWidget.show( ) ;
   return app.exec( ) ;
}
