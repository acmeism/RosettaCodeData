   / naive method
   / sqr[x] and sqrt[x] must be provided
   quf:{[a;b;c]; s:sqrt[sqr[b]-4*a*c];(-b+s;-b-s)%2*a}

   quf[0.5;-2.5;2]
1.0 4.0
   quf[1;8;15]
-5.0 -3.0
   quf[1;10;1]
-9.898979485566356 -0.10102051443364424
