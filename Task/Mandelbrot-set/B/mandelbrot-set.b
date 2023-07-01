main() {
  auto cx,cy,x,y,x2,y2;
  auto iter;

  auto xmin,xmax,ymin,ymax,maxiter,dx,dy;

  xmin = -8601;
  xmax =  2867;
  ymin = -4915;
  ymax =  4915;

  maxiter = 32;

  dx = (xmax-xmin)/79;
  dy = (ymax-ymin)/24;

  cy=ymin;
  while( cy<=ymax ) {
    cx=xmin;
    while( cx<=xmax ) {
      x = 0;
      y = 0;
      x2 = 0;
      y2 = 0;
      iter=0;
      while( iter<maxiter ) {
        if( x2+y2>16384 ) break;
        y = ((x*y)>>11)+cy;
        x = x2-y2+cx;
        x2 = (x*x)>>12;
        y2 = (y*y)>>12;
        iter++;
      }
      putchar(' '+iter);
      cx =+ dx;
    }
    putchar(13);
    putchar(10);
    cy =+ dy;
  }

  return(0);
}
