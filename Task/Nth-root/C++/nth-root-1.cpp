double NthRoot(double m_nValue, double index, double guess, double pc)
   {
       double result = guess;
       double result_next;
       do
       {
           result_next = (1.0/index)*((index-1.0)*result+(m_nValue)/(pow(result,(index-1.0))));
           result = result_next;
           pc--;
       }while(pc>1);
       return result;
   };
