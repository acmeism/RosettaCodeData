#include <QPushButton>
#include <QLabel>
#include <QVBoxLayout>
#include "clickcounter.h"

Counter::Counter( QWidget * parent ) : QWidget( parent ) {
   number = 0 ;
   countLabel = new QLabel( "There have been no clicks yet!" ) ;
   clicker = new QPushButton( "click me" ) ;
   connect ( clicker , SIGNAL( clicked( ) ) , this , SLOT( countClicks( ) ) ) ;
   myLayout = new QVBoxLayout ;
   myLayout->addWidget( countLabel ) ;
   myLayout->addWidget( clicker ) ;
   setLayout( myLayout ) ;
}

void Counter::countClicks( ) {
   number++ ;
   countLabel->setText( QString( "The button has been clicked %1 times!").arg( number ) ) ;
}
