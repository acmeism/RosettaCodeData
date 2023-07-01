#include <gadget/gadget.h>

LIB_GADGET_START

Main
   String body;
   Stack{
       Store ( body, Multi_copy( body,"<?xml version=\"1.0\" ?>",
                                 Parser( "root", "", Parser( "element", "","Some text here",
                                 NORMAL_TAG), NORMAL_TAG),
                                 NULL) );
   }

   Print "%s\n", body;

   Free secure body;
End
