​class HarshadNiven{ public static boolean find(int x)
   {
     int sum = 0,temp,var;
      var = x;
     while(x>0)
       {
         temp = x%10;
         sum = sum + temp;
         x = x/10;
       }
     if(var%sum==0) temp = 1;
     else temp = 0;
    return temp;
   }
 public static void main(String[] args)
  {
    int t,i;
     t = 0;
     for(i=1;t<20;i++)
      {
        if(find(i))
           {
             print(i + " ");
             t++;
           }
      }
     int x = 0;
     int y = 1000;
     while(x!=1)
      {
        if(find(y)) x = 1;
         y++;
      }
    println();
    println(y+1);
  }
}
