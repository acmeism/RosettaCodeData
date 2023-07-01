#include <QtGui>
#include "greytones.h"

MyWidget::MyWidget( ) {
   setGeometry( 0, 0 , 640 , 480 ) ;
}

void MyWidget::paintEvent ( QPaintEvent * ) {
   QBrush myBrush( Qt::SolidPattern ) ;
   QPainter myPaint( this ) ;
   int run = 0 ; //how often have we run through the loop ?
   int colorcomp = 0 ;
   for ( int columncount = 8 ; columncount < 128 ; columncount *= 2 ) {
      int colorgap = 255 / columncount ;
      int columnwidth = 640 / columncount ; // 640 being the window width
      int columnheight = 480 / 4 ; //we're looking at quarters
      if ( run % 2 == 0 ) { //we start with black columns
	 colorcomp = 0 ;
      }
      else { //we start with white columns
	 colorcomp = 255 ;
	 colorgap *= -1 ; //we keep subtracting color values
      }
      int ystart = 0 + columnheight * run ; //determines the y coordinate of the first column per row
      int xstart = 0 ;
      for ( int i = 0 ; i < columncount ; i++ ) {
	 myBrush.setColor( QColor( colorcomp, colorcomp , colorcomp ) ) ;
	 myPaint.fillRect( xstart , ystart , columnwidth , columnheight , myBrush ) ;
	 xstart += columnwidth ;
	 colorcomp += colorgap ; //we choose the next color
      }
      run++ ;
   }
}
