#include <gadget/gadget.h>
LIB_GADGET_START

Main
      int retVal=0;
      Assert( Arg_count == 2, fail_input );
      Get_arg_str( filename, 0 );
      Get_arg_float( number, 1 );

      Print "First argument (filename) = %s\n", filename;
      Print "Second argument (a number) = %f\n", number;

      Free secure filename;

   Exception( fail_input ){
      Msg_yellow("Use:\n  ./prog <number>\n");
      retVal=1;
   }
Return( retVal );
