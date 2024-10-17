#include <stdio.h>
#include <string.h>
#include <caml/mlvalues.h>
#include <caml/callback.h>

extern int Query (char * Data, size_t * Length)
{
   static value * closure_f = NULL;
   if (closure_f == NULL) {
       closure_f = caml_named_value("Query function cb");
   }
   value ret = caml_callback(*closure_f, Val_unit);
   *Length = Int_val(Field(ret, 1));
   strncpy(Data, String_val(Field(ret, 0)), *Length);
   return 1;
}

int main (int argc, char * argv [])
{
   char     Buffer [1024];
   unsigned Size = 0;

   caml_main(argv);  /* added from the original main */

   if (0 == Query (Buffer, &Size))
   {
      printf ("failed to call Query\n");
   }
   else
   {
      char * Ptr = Buffer;
      printf("size: %d\n", Size);
      while (Size-- > 0) putchar (*Ptr++);
      putchar ('\n');
   }
}
