with Ada.Wide_Wide_Text_IO; use Ada.Wide_Wide_Text_IO;
with League.JSON.Arrays;    use League.JSON.Arrays;
with League.JSON.Documents; use League.JSON.Documents;
with League.JSON.Objects;   use League.JSON.Objects;
with League.JSON.Values;    use League.JSON.Values;
with League.Strings;        use League.Strings;

procedure Main is

   function "+" (Item : Wide_Wide_String) return Universal_String
     renames To_Universal_String;

   JSON_String : constant Universal_String
     := +"{""name"":""Pingu"",""born"":1986}";

   Penguin : JSON_Object;
   Parents : JSON_Array;

begin
   Penguin.Insert (+"name", To_JSON_Value (+"Linux"));
   Penguin.Insert (+"born", To_JSON_Value (1992));

   Parents.Append (To_JSON_Value (+"Linus Torvalds"));
   Parents.Append (To_JSON_Value (+"Alan Cox"));
   Parents.Append (To_JSON_Value (+"Greg Kroah-Hartman"));

   Penguin.Insert (+"parents", To_JSON_Value (Parents));

   Put_Line (To_JSON_Document (Penguin).To_JSON.To_Wide_Wide_String);

   Penguin := From_JSON (JSON_String).To_Object;

   Parents := Empty_JSON_Array;

   Parents.Append (To_JSON_Value (+"Otmar Gutmann"));
   Parents.Append (To_JSON_Value (+"Silvio Mazzola"));

   Penguin.Insert (+"parents", To_JSON_Value (Parents));

   Put_Line (To_JSON_Document (Penguin).To_JSON.To_Wide_Wide_String);
end Main;
