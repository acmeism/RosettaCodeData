#include <gadget/gadget.h>

LIB_GADGET_START

Main
   String XML, body;
   Stack{
       Store ( XML, Parser( "element", "","Some text here", NORMAL_TAG) );
       Store ( XML, Parser( "root", "",XML, NORMAL_TAG) );
   } Stack_off;

   body = Multi_copy( body,"<?xml version=\"1.0\" ?>", XML, NULL);
   Print "%s\n", body;

   Free secure XML, body;
End
