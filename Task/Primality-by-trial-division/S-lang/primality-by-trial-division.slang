define is_prime(n)
{
   if (n == 2) return(1);
   if (n <= 1) return(0);
   if ((n & 1) == 0) return(0);

   variable mx = int(sqrt(n)), i;

   _for i (3, mx, 1) {
     if ((n mod i) == 0)
       return(0);
   }
   return(1);
}

define ptest()
{
   variable lst = {};

   _for $1 (1, 64, 1)
     if (is_prime($1))
       list_append(lst, string($1));
   print(strjoin(list_to_array(lst), ", "));
}
ptest();
