#ifndef CLICKCOUNTER_H
#define CLICKCOUNTER_H

#include <QWidget>
class QLabel ;
class QPushButton ;
class QVBoxLayout ;

class Counter : public QWidget {
    Q_OBJECT
public :
   Counter( QWidget * parent = 0 ) ;
private :
   int number ;
   QLabel *countLabel ;
   QPushButton *clicker ;
   QVBoxLayout *myLayout ;
private slots :
   void countClicks( ) ;
} ;
#endif
