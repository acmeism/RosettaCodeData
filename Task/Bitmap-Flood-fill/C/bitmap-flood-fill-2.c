// http://commons.wikimedia.org/wiki/File:Julia_immediate_basin_1_3.png

unsigned int f(unsigned int _iX, unsigned int _iY)
/*
   gives position of point (iX,iY) in 1D array  ; uses also global variables
   it does not check if index is good  so memory error is possible
*/
{return (_iX + (iYmax-_iY-1)*iXmax );}


int FillContour(int iXseed, int iYseed,  unsigned char color, unsigned char _data[])
{
  /*
     fills contour with black border ( color = iJulia)  using seed point inside contour
     and horizontal lines
     it starts from seed point, saves max right( iXmaxLocal) and max left ( iXminLocal) interior points of horizontal line,
     in new line ( iY+1 or iY-1) it computes new interior point  : iXmidLocal=iXminLocal + (iXmaxLocal-iXminLocal)/2;
     result is stored in _data array : 1D array of 1-bit colors ( shades of gray)
     it does not check if index of _data array is good  so memory error is possible
  */


  int iX, /* seed integer coordinate */
    iY=iYseed,
    /* most interior point of line iY */
    iXmidLocal=iXseed,
    /* min and max of interior points of horizontal line iY */
    iXminLocal,
    iXmaxLocal;
  int i ; /* index of _data array */;


  /* ---------  move up --------------- */
  do{
    iX=iXmidLocal;
    i =f(iX,iY); /* index of _data array */;

    /* move to right */
    while (_data[i]==iInterior)
      { _data[i]=color;
        iX+=1;
        i=f(iX,iY);
      }
    iXmaxLocal=iX-1;

    /* move to left */
    iX=iXmidLocal-1;
    i=f(iX,iY);
    while (_data[i]==iInterior)
      { _data[i]=color;
        iX-=1;
        i=f(iX,iY);
      }
    iXminLocal=iX+1;


    iY+=1; /* move up */
    iXmidLocal=iXminLocal + (iXmaxLocal-iXminLocal)/2; /* new iX inside contour */
    i=f(iXmidLocal,iY); /* index of _data array */;
    if ( _data[i]==iJulia)  break; /*  it should not cross the border */

  } while  (iY<iYmax);


  /* ------  move down ----------------- */
  iXmidLocal=iXseed;
  iY=iYseed-1;


  do{
    iX=iXmidLocal;
    i =f(iX,iY); /* index of _data array */;

    /* move to right */
    while (_data[i]==iInterior) /*  */
      { _data[i]=color;
        iX+=1;
        i=f(iX,iY);
      }
    iXmaxLocal=iX-1;

    /* move to left */
    iX=iXmidLocal-1;
    i=f(iX,iY);
    while (_data[i]==iInterior) /*  */
      { _data[i]=color;
        iX-=1; /* move to right */
        i=f(iX,iY);
      }
    iXminLocal=iX+1;

    iY-=1; /* move down */
    iXmidLocal=iXminLocal + (iXmaxLocal-iXminLocal)/2; /* new iX inside contour */
    i=f(iXmidLocal,iY); /* index of _data array */;
    if ( _data[i]==iJulia)  break; /*  it should not cross the border */
  } while  (0<iY);

  /* mark seed point by big pixel */
  const int iSide =iXmax/500; /* half of width or height of big pixel */
  for(iY=iYseed-iSide;iY<=iYseed+iSide;++iY){
    for(iX=iXseed-iSide;iX<=iXseed+iSide;++iX){
      i= f(iX,iY); /* index of _data array */
      _data[i]=10;}}

  return 0;
}
