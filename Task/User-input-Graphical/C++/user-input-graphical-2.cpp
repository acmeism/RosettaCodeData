#include <QLineEdit>
#include <QLabel>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QString>
#include "task.h"

EntryWidget::EntryWidget ( QWidget *parent )
   : QWidget( parent ) {
      entryLayout = new QVBoxLayout( this ) ;
      stringlabel = new QLabel( "Enter a string!" ) ;
      stringinput = new QLineEdit( "" ) ;
      stringinput->setMaxLength( 20 ) ;
      stringinput->setInputMask( QString( "AAAAAAAAAAAAAAAAAAA" ) ) ;
      upperpart = new QHBoxLayout ;
      upperpart->addWidget( stringlabel ) ;
      upperpart->addWidget( stringinput ) ;
      numberlabel = new QLabel( "Enter a number!" ) ;
      numberinput = new QLineEdit( "0" ) ;
      numberinput->setMaxLength( 5 ) ;
      numberinput->setInputMask( QString( "99999" ) ) ;
      lowerpart = new QHBoxLayout ;
      lowerpart->addWidget( numberlabel ) ;
      lowerpart->addWidget( numberinput ) ;
      entryLayout->addLayout( upperpart ) ;
      entryLayout->addLayout( lowerpart ) ;
      setLayout( entryLayout ) ;
}
