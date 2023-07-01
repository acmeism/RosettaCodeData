//iteration with while
long long int factorial(long long int n)
{
   long long int r = 1;
   while(1<n)
       r *= n--;
   return r;
}
