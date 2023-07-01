#ifndef INTERACTION_H
#define INTERACTION_H
#include <QWidget>

class QPushButton ;
class QLineEdit ;
class QVBoxLayout ;
class MyWidget : public QWidget {
   Q_OBJECT

public :
   MyWidget( QWidget *parent = 0 ) ;
private :
   QLineEdit *entryField ;
   QPushButton *increaseButton ;
   QPushButton *randomButton ;
   QVBoxLayout *myLayout ;
private slots :
   void doIncrement( ) ;
   void findRandomNumber( ) ;
} ;
#endif
