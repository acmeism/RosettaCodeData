with Ada.Strings.Unbounded;
with Config_File_Parser;
pragma Elaborate_All (Config_File_Parser);

package Config is

   function TUS (S : String) return Ada.Strings.Unbounded.Unbounded_String
      renames Ada.Strings.Unbounded.To_Unbounded_String;
   --  Convenience rename. TUS is much shorter than To_Unbounded_String.

   type Keys is (
      FULLNAME,
      FAVOURITEFRUIT,
      NEEDSPEELING,
      SEEDSREMOVED,
      OTHERFAMILY);
   --  These are the valid configuration keys.

   type Defaults_Array is
     array (Keys) of Ada.Strings.Unbounded.Unbounded_String;
   --  The array type we'll use to hold our default configuration settings.

   Defaults_Conf : Defaults_Array :=
     (FULLNAME       => TUS ("John Doe"),
      FAVOURITEFRUIT => TUS ("blackberry"),
      NEEDSPEELING   => TUS ("False"),
      SEEDSREMOVED   => TUS ("False"),
      OTHERFAMILY    => TUS ("Daniel Defoe, Ada Byron"));
   --  Default values for the Program object. These can be overwritten by
   --  the contents of the rosetta.cfg file(see below).

   package Rosetta_Config is new Config_File_Parser (
      Keys => Keys,
      Defaults_Array => Defaults_Array,
      Defaults => Defaults_Conf,
      Config_File => "rosetta.cfg");
   --  Instantiate the Config configuration object.

end Config;
