with Ada.Text_IO;
with GNATCOLL.JSON;

procedure JSON_Test is
   use Ada.Text_IO;
   use GNATCOLL.JSON;

   JSON_String : constant String := "{""name"":""Pingu"",""born"":1986}";

   Penguin : JSON_Value := Create_Object;
   Parents : JSON_Array;
begin
   Penguin.Set_Field (Field_Name => "name",
                      Field      => "Linux");

   Penguin.Set_Field (Field_Name => "born",
                      Field      => 1992);

   Append (Parents, Create ("Linus Torvalds"));
   Append (Parents, Create ("Alan Cox"));
   Append (Parents, Create ("Greg Kroah-Hartman"));

   Penguin.Set_Field (Field_Name => "parents",
                      Field      => Parents);

   Put_Line (Penguin.Write);

   Penguin := Read (JSON_String, "json.errors");

   Penguin.Set_Field (Field_Name => "born",
                      Field      => 1986);

   Parents := Empty_Array;
   Append (Parents, Create ("Otmar Gutmann"));
   Append (Parents, Create ("Silvio Mazzola"));

   Penguin.Set_Field (Field_Name => "parents",
                      Field      => Parents);

   Put_Line (Penguin.Write);
end JSON_Test;
