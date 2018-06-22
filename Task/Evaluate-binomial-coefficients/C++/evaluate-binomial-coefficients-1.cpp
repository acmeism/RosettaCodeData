double Factorial(double nValue)
   {
       double result = nValue;
       double result_next;
       double pc = nValue;
       do
       {
           result_next = result*(pc-1);
           result = result_next;
           pc--;
       }while(pc>2);
       nValue = result;
       return nValue;
   }

double binomialCoefficient(double n, double k)
   {
       if (abs(n - k) < 1e-7 || k  < 1e-7) return 1.0;
       if( abs(k-1.0) < 1e-7 || abs(k - (n-1)) < 1e-7)return n;
       return Factorial(n) /(Factorial(k)*Factorial((n - k)));
   }
