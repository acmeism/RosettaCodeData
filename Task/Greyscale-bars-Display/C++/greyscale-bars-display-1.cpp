#ifndef MYWIDGET_H
#define MYWIDGET_H
#include <QWidget>

class QPaintEvent ;

class MyWidget : public QWidget {
public :
   MyWidget( ) ;

protected :
   void paintEvent( QPaintEvent * ) ;
} ;
#endif
