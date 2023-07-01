//compile using the new dylan.NET v, 11.5.1.2 or later
//use mono to run the compiler
#refstdasm mscorlib.dll

import System

assembly stderrex exe
ver 1.1.0.0

class public Program

   method public static void main()
      Console::get_Error()::WriteLine("Goodbye World!")
   end method

end class
