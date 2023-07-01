#ifndef TASK_H
#define TASK_H

#include <QWidget>

class QPushButton ;
class QString ;
class QLineEdit ;
class QLabel ;
class QVBoxLayout ;
class QHBoxLayout ;

class MyWidget : public QWidget {

    Q_OBJECT
public:
   MyWidget( QWidget *parent = 0 ) ;
private slots:
   void buttonChange( const QString & ) ;
   void addField( ) ;
   void subtractField( ) ;
private :
   QVBoxLayout *thisWidgetLayout ;
   QLabel *instruction ;
   QPushButton *increment ;
   QPushButton *decrement ;
   QLineEdit *entryField ;
   QHBoxLayout *lowerPart ;
} ;
#endif
