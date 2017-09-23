% Simplistic prime-test from prime-by-trial-division:
define is_prime(n)
{
   if (n <= 1) return(0);
   if (n == 2) return(1);
   if ((n & 1) == 0) return(0);

   variable mx = int(sqrt(n)), i;

   _for i (3, mx, 1) {
     if ((n mod i) == 0)
       return(0);
   }
   return(1);
}

define population(n)
{
   variable pc = 0;
   do {
      if (n & 1) pc++;
      n /= 2;
   }
   while (n);
   return(pc);
}

define is_pernicious(n)
{
   return(is_prime(population(n)));
}

variable plist = {}, n = 0;
while (length(plist) < 25) {
   n++;
   if (is_pernicious(n))
     list_append(plist, string(n));
}
print(strjoin(list_to_array(plist), " "));

plist = {};
_for n (888888877, 888888888, 1) {
   if (is_pernicious(n))
     list_append(plist, string(n));
}
print(strjoin(list_to_array(plist), " "));
