with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Longest_Prefix is

   package Common_Prefix is
      procedure Reset;
      procedure Consider (Item : in String);
      function Prefix return String;
   end Common_Prefix;

   package body Common_Prefix
   is
      use Ada.Strings.Unbounded;
      Common : Unbounded_String;
      Active : Boolean := False;

      procedure Reset is
      begin
         Common := Null_Unbounded_String;
         Active := False;
      end Reset;

      procedure Consider (Item : in String) is
         Len : constant Natural := Natural'Min (Length (Common), Item'Length);
      begin
         if not Active then
            Active := True;
            Common := To_Unbounded_String (Item);
         else
            for I in 1 .. Len loop
               if Element (Common, I) /= Item (Item'First + I - 1) then
                  Head (Common, I - 1);
                  return;
               end if;
            end loop;
            Head (Common, Len);
         end if;
      end Consider;

      function Prefix return String is (To_String (Common));

   end Common_Prefix;

   use Common_Prefix;
begin
   Consider ("interspecies");   Consider ("interstellar");   Consider ("interstate");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;   Consider ("throne");   Consider ("throne");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;   Consider ("throne");   Consider ("dungeon");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;   Consider ("prefix");   Consider ("suffix");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;   Consider ("foo");   Consider ("foobar");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;   Consider ("foo");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;   Consider ("");
   Ada.Text_IO.Put_Line (Prefix);

   Reset;
   Ada.Text_IO.Put_Line (Prefix);

end Longest_Prefix;
