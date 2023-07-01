#include <gadget/gadget.h>

LIB_GADGET_START

Main
   String XML, body;

   Get_fn_let( XML, Parser( "element", "","Some text here", NORMAL_TAG) );
   Get_fn_let( XML, Parser( "root", "",XML, NORMAL_TAG) );

   body = Multi_copy( body,"<?xml version=\"1.0\" ?>", XML, NULL);
   Print "%s\n", body;

   Free secure XML, body;
End
