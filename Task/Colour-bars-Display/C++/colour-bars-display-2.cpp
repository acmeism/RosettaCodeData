#include <QtGui>
#include "colorbars.h"

MyWidget::MyWidget( ) :
   width( 640 ) ,
   height( 240 ) ,
   colornumber( 8 ) {
      setGeometry( 0, 0 , width , height ) ;
}

void MyWidget::paintEvent ( QPaintEvent * ) {
   int rgbtriplets[ ] = { 0 , 0 , 0 , 255 , 0 , 0 , 0 , 255 , 0 ,
      0 , 0 , 255 , 255 , 0 , 255 , 0 , 255 , 255 , 255 , 255 , 0 ,
      255 , 255 , 255 } ;
   QPainter myPaint( this ) ;
   int rectwidth = width / colornumber ; //width of one rectangle
   int xstart = 1 ; //x coordinate of the first rectangle
   int offset = -1  ; //to allow for ++offset to define the red value even in the first run of the loop below
   for ( int i = 0 ; i < colornumber ; i++ ) {
      QColor rectColor ;
      rectColor.setRed( rgbtriplets[ ++offset ] ) ;
      rectColor.setGreen( rgbtriplets[ ++offset ] ) ;
      rectColor.setBlue( rgbtriplets[ ++offset ] ) ;
      myPaint.fillRect( xstart , 0 , rectwidth , height - 1 , rectColor ) ;
      xstart += rectwidth + 1 ;
   }
}
