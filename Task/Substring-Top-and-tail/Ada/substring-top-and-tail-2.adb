with Ada.Text_IO;
with Ada.Strings.UTF_Encoding.Wide_Strings;

procedure Remove_Characters
is
   use Ada.Text_IO;
   use Ada.Strings.UTF_Encoding;
   use Ada.Strings.UTF_Encoding.Wide_Strings;

   S : String := "upraisers";
   U : Wide_String := Decode (UTF_8_String'(S));

   function To_String (X : Wide_String)return String
   is
   begin
      return String (UTF_8_String'(Encode (X)));
   end To_String;

begin
   Put_Line
     (To_String
        ("Full String:   """ & U & """"));
   Put_Line
     (To_String
        ("Without_First: """ & U (U'First + 1 .. U'Last) & """"));
   Put_Line
     (To_String
        ("Without_Last:  """ & U (U'First   .. U'Last - 1) & """"));
   Put_Line
     (To_String
        ("Without_Both:  """ & U (U'First + 1 .. U'Last - 1) & """"));

end Remove_Characters;
