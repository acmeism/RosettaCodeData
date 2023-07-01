int palindrome(const char *s)
{
   const char *t; /* t is a pointer that traverses backwards from the end */
   for (t = s; *t != '\0'; t++) ; t--; /* set t to point to last character */
   while (s < t)
   {
     if ( *s++ != *t-- ) return 0;
   }
   return 1;
}
