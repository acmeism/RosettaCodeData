public static long gcd(long a, long b){
   long factor= Math.max(a, b);
   for(long loop= factor;loop > 1;loop--){
      if(a % loop == 0 && b % loop == 0){
         return loop;
      }
   }
   return 1;
}
