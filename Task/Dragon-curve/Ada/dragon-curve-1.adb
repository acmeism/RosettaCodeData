-- FILE: dragon_curve.gpr --
with "gtkada";

project Dragon_Curve is
   Adaflags    := External_As_List ("ADAFLAGS", " ");
   Ldflags     := External_As_List ("LDFLAGS", " ");

   for Languages use ("Ada");
   for Main use ("dragon_curve.adb");
   for Source_Dirs use ("./");
   for Object_Dir use "obj/";
   for Exec_Dir use ".";

   package Compiler is
      for Switches ("Ada") use ("-g", "-O0", "-gnaty-s", "-gnatwJ")
         & Adaflags;
   end Compiler;

   package Linker is
      for Leading_Switches ("Ada") use Ldflags;
   end Linker;

end Dragon_Curve;
