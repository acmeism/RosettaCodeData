//to be compiled using dylan.NET v. 11.5.1.2 or later.
#refstdasm mscorlib.dll

import System

assembly concatex exe
ver 1.3.0.0

class public Program

   method public static void main()
        var s as string = "hello"
        Console::Write(s)
        Console::WriteLine(" literal")
        var s2 as string = s + " literal"
        Console::WriteLine(s2)
  end method

end class
