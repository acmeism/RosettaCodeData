#include <gadget/gadget.h>

LIB_GADGET_START

Main
   String v, w = "this message is a message";

   Let( v, "Hello world!");
   Print "v = %s\nw = %s\n\n", v,w;

   Get_fn_let( v, Upper(w) );

   Print "v = %s\nw = %s\n\n", v,w;

   Stack{
       Store ( v, Str_tran_last( Upper(w), "MESSAGE", "PROOF" ) );
   }Stack_off;

   Print "v = %s\nw = %s\n\n", v,w;

   Free secure v, w;

End
