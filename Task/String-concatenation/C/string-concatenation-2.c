#include <gadget/gadget.h>

LIB_GADGET_START

Main

   String v="Mensaje lanzado al mar", w=Space(100);
   Stack{
     Store ( w, Pad_c( Multi_cat(w, Upper( Str_tran_all(v,"lanzado","tirado",1)),\
                       " adentro de una botella", NULL ), '-', 70 ));
  }
  puts(w);
  Free secure v, w;
End
