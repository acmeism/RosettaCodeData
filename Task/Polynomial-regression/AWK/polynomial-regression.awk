BEGIN{
  i = 0;
  xa[i] =  0; i++;
  xa[i] =  1; i++;
  xa[i] =  2; i++;
  xa[i] =  3; i++;
  xa[i] =  4; i++;
  xa[i] =  5; i++;
  xa[i] =  6; i++;
  xa[i] =  7; i++;
  xa[i] =  8; i++;
  xa[i] =  9; i++;
  xa[i] = 10; i++;
  i = 0;
  ya[i] =  1; i++;
  ya[i] =  6; i++;
  ya[i] = 17; i++;
  ya[i] = 34; i++;
  ya[i] = 57; i++;
  ya[i] = 86; i++;
  ya[i] =121; i++;
  ya[i] =162; i++;
  ya[i] =209; i++;
  ya[i] =262; i++;
  ya[i] =321; i++;
  exit;
}
{
  # (nothing to do)
}
END{
  a = 0; b = 0; c = 0;  # globals - will change by regression()
  regression(xa,ya);

  printf("y = %6.2f x^2 + %6.2f x + %6.2f\n",c,b,a);
  printf("%-13s %-8s\n","Input","Approximation");
  printf("%-6s %-6s %-8s\n","x","y","y^")
  for (i=0;i<length(xa);i++) {
    printf("%6.1f %6.1f %8.3f\n",xa[i],ya[i],eval(a,b,c,xa[i]));
  }
}

function eval(a,b,c,x) {
  return a+b*x+c*x*x;
}
                           # locals
function regression(x,y,   n,xm,ym,x2m,x3m,x4m,xym,x2ym,sxx,sxy,sxx2,sx2x2,sx2y) {
  n = 0
  xm = 0.0;
  ym = 0.0;
  x2m = 0.0;
  x3m = 0.0;
  x4m = 0.0;
  xym = 0.0;
  x2ym = 0.0;

  for (i in x) {
    xm  += x[i];
    ym  += y[i];
    x2m += x[i] * x[i];
    x3m += x[i] * x[i] * x[i];
    x4m += x[i] * x[i] * x[i] * x[i];
    xym += x[i] * y[i];
    x2ym += x[i] * x[i] * y[i];
    n++;
  }
  xm = xm / n;
  ym = ym / n;
  x2m = x2m / n;
  x3m = x3m / n;
  x4m = x4m / n;
  xym = xym / n;
  x2ym = x2ym / n;

  sxx = x2m - xm * xm;
  sxy = xym - xm * ym;
  sxx2 = x3m - xm * x2m;
  sx2x2 = x4m - x2m * x2m;
  sx2y = x2ym - x2m * ym;

  b = (sxy  * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
  c = (sx2y * sxx   - sxy  * sxx2) / (sxx * sx2x2 - sxx2 * sxx2);
  a = ym - b * xm - c * x2m;
}
