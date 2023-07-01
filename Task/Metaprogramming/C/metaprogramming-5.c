#include <gadget/gadget.h>
LIB_GADGET_START

Main
   String w, v="María tenía un corderito";

   Stack{
       Store( v, Substr(v, Str_at("tenía",v),Str_len( Upper(v) )) );
       Store( v, Trim(Left( Upper(v), Str_at("CORDERITO",Upper(v))-1)));
   }Stack_off;

   Print "msg stack : [%s]\n\n", v;

   Let( v, "María tenía un corderito");

  /* Str_len() sirve sin stack, pero en este caso es mejor usar strlen() de C. */
   w = Substr(v, Str_at("tenía",v),Str_len(v));
   Print "msg normal: %s\n", w;

   Free secure w,v;
End
