with Ada.Text_Io;
with Ada.Containers.Indefinite_Ordered_Maps;

procedure Merge_Maps is
   use Ada.Text_Io;

   type Key_Type   is new String;
   type Value_Type is new String;

   package Maps is
     new Ada.Containers.Indefinite_Ordered_Maps (Key_Type     => Key_Type,
                                                 Element_Type => Value_Type);
   use Maps;

   function Merge (Original : Map; Update : Map) return Map is
      Result : Map    := Original;
      Cur    : Cursor := Update.First;
   begin
      while Has_Element (Cur) loop
         if Original.Contains (Key (Cur)) then
            Result.Replace_Element (Result.Find (Key (Cur)),
                                    Element (Cur));
         else
            Result.Insert (Key (Cur), Element (Cur));
         end if;
         Next (Cur);
      end loop;
      return Result;
   end Merge;

   procedure Put_Map (M : Map) is
      Cur : Cursor := M.First;
   begin
      while Has_Element (Cur) loop
         Put (String (Key (Cur)));
         Set_Col (12);
         Put (String (Element (Cur)));
         New_Line;
         Next (Cur);
      end loop;
   end Put_Map;

   Original : Map;
   Update   : Map;
   Result   : Map;
begin
   Original.Insert ("name", "Rocket Skates");
   Original.Insert ("price", "12.75");
   Original.Insert ("color", "yellow");

   Update.Insert ("price", "15.25");
   Update.Insert ("color", "red");
   Update.Insert ("year", "1974");

   Result := Merge (Original, Update);

   Put_Line ("Original:");
   Put_Map (Original);
   New_Line;

   Put_Line ("Update:");
   Put_Map (Update);
   New_Line;

   Put_Line ("Result of merge:");
   Put_Map (Result);
   New_Line;

end Merge_Maps;
