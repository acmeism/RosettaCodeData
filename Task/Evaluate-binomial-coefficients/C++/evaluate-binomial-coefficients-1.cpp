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

double EvaluateBinomialCoefficient(double nValue, double nValue2)
   {
       double result;
       if(nValue2 == 1)return nValue;
       result = (Factorial(nValue))/(Factorial(nValue2)*Factorial((nValue - nValue2)));
       nValue2 = result;
       return nValue2;
   }
