 public class almostprime
{
public static boolean kprime(int n,int k)
  {
    int i,div=0;
     for(i=2;(i*i <= n) && (div<k);i++)
      {
        while(n%i==0)
          {
            n = n/i;
            div++;
          }
      }
   return div + ((n > 1)?1:0) == k;
  }
  public static void main(String[] args)
    {
      int i,l,k;
       for(k=1;k<=5;k++)
        {
          println("k = " + k + ":");
           l = 0;
            for(i=2;l<10;i++)
              {
                if(kprime(i,k))
                {
                  print(i + " ");
                  l++;
                }
              }
          println();
        }
     }
}​
