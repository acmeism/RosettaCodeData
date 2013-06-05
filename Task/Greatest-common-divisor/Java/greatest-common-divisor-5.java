public static long gcd(long a, long b){
   if(a == 0) return b;
   if(b == 0) return a;
   if(a > b) return gcd(b, a % b);
   return gcd(a, b % a);
}
