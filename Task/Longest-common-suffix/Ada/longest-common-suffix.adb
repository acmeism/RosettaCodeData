with Ada.Strings.Unbounded;
with Ada.Text_Io.Unbounded_IO;

procedure Longest_Common_Suffix is
   use Ada.Text_Io;
   use Ada.Text_Io.Unbounded_Io;
   use Ada.Strings.Unbounded;

   subtype Ustring is Unbounded_String;

   function "+"(S : String) return Ustring
     renames To_Unbounded_String;

   type String_List is array (Positive range <>) of Ustring;

   function Longest_Suffix (List : String_List) return Ustring is
      Suffix : Ustring := List (List'First);
   begin
      for A in List'First + 1 .. List'Last loop
         declare
            Word  : Ustring renames List (A);
            Found : Boolean := False;
            Len   : constant Natural :=
              Natural'Min (Length (Suffix), Length (Word));
         begin
            for P in reverse 1 .. Len loop
               if Tail (Suffix, P) = Tail (Word, P) then
                  Suffix := Tail (Word, P);
                  Found := True;
                  exit;
               end if;
            end loop;
            if not Found then
               Suffix := +"";
            end if;
         end;
      end loop;
      return Suffix;
   end Longest_Suffix;

   procedure Put (List : String_List) is
   begin
      Put ("[");
      for S of List loop
         Put ("'"); Put (S); Put ("' ");
      end loop;
      Put ("]");
   end Put;

   procedure Test (List : String_List) is
   begin
      Put (List); Put (" -> '");
      Put (Longest_Suffix (List));
      Put ("'");
      New_Line;
   end Test;

   Case_1 : constant String_List := (+"baabababc", +"baabc", +"bbbabc");
   Case_2 : constant String_List := (+"baabababc", +"baabc", +"bbbazc");
   Case_3 : Constant String_List := (+"Sunday", +"Monday", +"Tuesday",
                                     +"Wednesday", +"Thursday", +"Friday",
                                     +"Saturday");
   Case_4 : constant String_List := (+"longest", +"common", +"suffix");
   Case_5 : constant String_List := (1 => +"suffix");
   Case_6 : Constant String_List := (1 => +"");
begin
   Test (Case_1);
   Test (Case_2);
   Test (Case_3);
   Test (Case_4);
   Test (Case_5);
   Test (Case_6);
end Longest_Common_Suffix;
