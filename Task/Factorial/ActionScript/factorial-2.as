public static function factorial(n:int):int
{
   if (n < 0)
       return 0;

   if (n == 0)
       return 1;

   return n * factorial(n - 1);
}
