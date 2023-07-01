#ifndef TASK_H
#define TASK_H

#include <QWidget>

class QLabel ;
class QLineEdit ;
class QVBoxLayout ;
class QHBoxLayout ;

class EntryWidget : public QWidget {

   Q_OBJECT
public :
   EntryWidget( QWidget *parent = 0 ) ;
private :
   QHBoxLayout *upperpart , *lowerpart ;
   QVBoxLayout *entryLayout ;
   QLineEdit *stringinput ;
   QLineEdit *numberinput ;
   QLabel *stringlabel ;
   QLabel *numberlabel ;
} ;

#endif
