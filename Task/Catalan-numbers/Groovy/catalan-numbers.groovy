class Catalan
{
 public static void main(String[] args)
  {
    BigInteger N = 15;
    BigInteger k,n,num,den;
    BigInteger  catalan;
      print(1);
       for(n=2;n<=N;n++)
          {
            num = 1;
            den = 1;
              for(k=2;k<=n;k++)
                 {
                    num = num*(n+k);
                    den = den*k;
                    catalan = num/den;
                 }
            println(catalan);
          }

  }
}
