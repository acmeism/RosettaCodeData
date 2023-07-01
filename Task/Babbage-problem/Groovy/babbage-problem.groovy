int n=104;   ///starting point
while( (n**2)%1000000 != 269696 )
    {  if (n%10==4)   n=n+2;
       if (n%10==6)   n=n+8;
    }
    println n+"^2== "+n**2 ;
