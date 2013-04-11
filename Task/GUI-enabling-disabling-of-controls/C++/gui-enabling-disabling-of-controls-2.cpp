#include <QtGui>
#include <QString>
#include "task.h"

MyWidget::MyWidget ( QWidget *parent )
   : QWidget( parent ) {
   thisWidgetLayout = new QVBoxLayout ( this )  ;
   instruction = new QLabel ;
   instruction->setText( "Enter a number between 1 and 10 ! Numbers above 10 are decremented, below 0 incremented!" ) ;
   instruction->setWordWrap( true ) ;
   lowerPart = new QHBoxLayout ;
   entryField = new QLineEdit( "0" ) ;
   increment = new QPushButton( "Increment" ) ;
   decrement = new QPushButton( "Decrement" ) ;
   increment->setDefault( true ) ;
   connect( entryField , SIGNAL ( textChanged ( const QString &  ) ) ,
	    this , SLOT ( buttonChange( const QString & )) ) ;
   connect( entryField , SIGNAL ( textEdited ( const QString &  ) ) ,
	    this , SLOT ( buttonChange( const QString & )) ) ;
   connect( increment , SIGNAL ( clicked( ) ) , this ,
	 SLOT ( addField( ) )) ;
   connect( decrement , SIGNAL ( clicked( ) ) , this ,
	 SLOT ( subtractField( ))) ;
   lowerPart->addWidget( entryField ) ;
   lowerPart->addWidget( increment ) ;
   lowerPart->addWidget( decrement ) ;
   thisWidgetLayout->addWidget( instruction ) ;
   thisWidgetLayout->addLayout( lowerPart ) ;
   setLayout( thisWidgetLayout ) ;
}

void MyWidget::buttonChange( const QString & text ) {
   bool ok ;
   increment->setEnabled( text.toInt( &ok, 10 ) < 10 ) ;
   increment->setDisabled( text.toInt( &ok, 10 ) > 9 ) ;
   decrement->setEnabled( text.toInt( &ok, 10 ) > 0 ) ;
   decrement->setDisabled( text.toInt( &ok, 10 ) <= 0 ) ;
   if ( ! ( text == "0" ) )
      entryField->setReadOnly( true ) ;
}

void MyWidget::addField( ) {
   bool ok ;
   int number = entryField->text( ).toInt( &ok , 10 ) ;
   number++ ;
   entryField->setText( QString("%1").arg( number )) ;
}

void MyWidget::subtractField( ) {
   bool ok ;
   int number = entryField->text( ).toInt( &ok , 10 ) ;
   number-- ;
   entryField->setText( QString("%1").arg( number )) ;
}
