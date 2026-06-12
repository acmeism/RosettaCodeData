with Ada.Text_Io;  use Ada.Text_Io;

procedure Exactly_3 is

   type List_Type is array (Positive range <>) of Integer;

   function Has_3_Consecutive (List : List_Type) return Boolean is
      Conseq : constant Natural := 3;
      Match  : constant Integer := 3;
      Count  : Natural := 0;
   begin
      for Element of List loop
         if Element = Match then
            Count := Count + 1;
         else
            if Count = Conseq then
               return True;
            else
               Count := 0;
            end if;
         end if;
      end loop;
      return (Count = Conseq);
   end Has_3_Consecutive;

   procedure Put (List : List_Type) is
   begin
      Put ("[");
      for Element of List loop
         Put (Integer'Image (Element));
         Put (" ");
      end loop;
      Put ("]");
   end Put;

   procedure Test (List : List_Type) is
      Result : constant Boolean := Has_3_Consecutive (List);
   begin
      Put (List);
      Put (" -> ");
      Put (Boolean'Image (Result));
      New_Line;
   end Test;

begin
   Test ((9,3,3,3,2,1,7,8,5));
   Test ((5,2,9,3,3,7,8,4,1));
   Test ((1,4,3,6,7,3,8,3,2));
   Test ((1,2,3,4,5,6,7,8,9));
   Test ((4,6,8,7,2,3,3,3,1));

   Test ((4,6,8,7,2,3,3,3,3)); -- Four tailing
   Test ((4,6,8,7,2,1,3,3,3)); -- Three tailing
   Test ((1,3,3,3,3,4,5,8,9));

   Test ((3,3,3,3));
   Test ((3,3,3));
   Test ((3,3));
   Test ((1 => 3));        -- One element
   Test ((1 .. 0 => <>));  -- No elements
end Exactly_3;
