#include <gadget/gadget.h>

LIB_GADGET_START

Main
   Cls;

   String text;
   int number=0;

   At 5,5;  Print "Enter text   : ";
   Atrow 7; Print "Enter ‘75000’: ";
   Atcol 20;

   Atrow 5; Fn_let(text, Input ( text, 30 ) );
   Free secure text;

   Atrow 7; Stack{
               while (number!=75000 )
                   /*into stack, Input() not need var*/
                   number = Str2int( Input ( NULL, 6 ) );
            }Stack_off;

   Prnl;
End
