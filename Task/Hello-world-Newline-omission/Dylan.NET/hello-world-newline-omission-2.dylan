//compile using the new dylan.NET v, 11.5.1.2 or later
//use mono to run the compiler
#refstdasm mscorlib.dll

import System

assembly gdbyeex exe
ver 1.2.0.0

class public Program

   method public static void main()
      Console::Write("Goodbye, World!")
   end method

end class
