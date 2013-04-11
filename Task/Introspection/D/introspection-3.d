static if ( is(typeof(abs(bloop))) ) {
   typeof(abs(bloop)) computeAbsBloop()  {
      return abs(bloop);
   }
 }
