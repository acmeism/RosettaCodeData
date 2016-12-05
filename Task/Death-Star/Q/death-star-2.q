w:400; h:300; r:150; l:-0.5 0.7 0.5
sqrt0:{$[x>0;sqrt x;0]};

/ get x,y,z position of point on sphere given x,y,r

z:{[x;y;r]sqrt0((r*r)-((x*x)+(y*y)))};

/ get diffused light at point on sphere

is:{[x;y;r]
   z0:z[x;y;r];
   s:(x;y;z0)%r;
   $[z0>0;i:0.5*1+(+/)(s*l);i:0];
   i};

/ get pixel value at given image position

fcn:{[xpx;ypx]
   x:xpx-w%2;
   y:ypx-h%2;
   z1:z[x;y;r];
   x2:x+190;
   z2:170-z[x2;y;r];
   $[(r*r)<((x*x)+(y*y));
      $[y>-50;
          i:3#0;
          i:200 100 50];
      $[z2>z1;
         i:3#is[x;y;r]*140;
         i:3#is[(-1*x2);(-1*y);r]*120]
   ];
   "i"$i};

/ do it ...

\l bmp.q
fn:`:demo.bmp;
writebmp[w;h;fcn;fn];
