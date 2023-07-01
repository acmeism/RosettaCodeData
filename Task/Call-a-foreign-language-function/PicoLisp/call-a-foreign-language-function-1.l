(load "@lib/gcc.l")

(gcc "str" NIL                # The 'gcc' function passes all text
   'duptest )                 # until /**/ to the C compiler

any duptest(any ex) {
   any x = evSym(cdr(ex));    // Accept a symbol (string)
   char str[bufSize(x)];      // Create a buffer to unpack the name
   char *s;

   bufString(x, str);         // Upack the string
   s = strdup(str);           // Make a duplicate
   x = mkStr(s);              // Build a new Lisp string
   free(s);                   // Dispose the duplicate
   return x;
}
/**/

(println 'Duplicate (duptest "Hello world!"))
