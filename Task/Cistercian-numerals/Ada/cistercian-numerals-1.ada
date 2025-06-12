--  cistercian_numerals.adb
--
--  test program for the Cistercian Representation Library
--  possibly overengineered in order to demonstrate use of types,
--  conditions, etc.
--  threw in some exception handling

--  modern Ada
pragma Ada_2022;

pragma Assertion_Policy (Check);

--  imports

with Ada.Text_IO;

with Cistercian;
with Cistercian.Ascii;
with Cistercian.Ascii_Requirements;

procedure Cistercian_Numerals is

   package IO renames Ada.Text_IO;

   Test_Values : constant array (1 .. 8) of Cistercian.Representable_Range :=
     [0, 1, 20, 300, 4_000, 5_555, 6_789, 1_983];
   --  test values required by task
   User_Value  : Integer;
   --  value user requests

   Temp      : Integer;
   Dimension : Cistercian.Ascii_Requirements.Valid_Dimension;

begin

   loop
      begin
         IO.Put_Line ("How large would you like your Cistercian numerals?");
         IO.Put_Line ("(You must supply an odd number greater than 5)");
         IO.Put ("> ");
         Dimension :=
           Cistercian.Ascii_Requirements.Valid_Dimension'Value (IO.Get_Line);
         --  kind of perplexed why I have to assert this
         --  when the dynamic predicate should do so
         pragma
           Assert (Dimension in Cistercian.Ascii_Requirements.Valid_Dimension);
         exit;
      exception
         when others =>
            IO.Put_Line ("You must supply an odd number greater than 5");
      end;
   end loop;

   declare
      package Cist_Ascii is new Cistercian.Ascii (Dimension);
   begin

      --  first print test values
      for Value of Test_Values loop
         begin
            IO.Put_Line
              ("The Cistercian representation of" & Value'Image & " is:");
            Cist_Ascii.Put (Cistercian.From (Value));
            IO.New_Line;
         exception
            when others =>
               IO.Put_Line ("Hit an unrecoverable error. Terminating");
               return;
         end;
      end loop;

      --  now let user choose own values
      loop
         begin
            IO.Put ("What other value would you like to see? ");
            IO.Put_Line ("(enter a negative number to stop) ");
            IO.Put ("? ");
            User_Value := Integer'Value (IO.Get_Line);
            Cist_Ascii.Put (Cistercian.From (User_Value));
            IO.New_Line;
         exception
            when others =>
               if User_Value < 0 then
                  exit;
               end if;
               IO.Put_Line ("Please enter a valid number from 0 to 9999.");
               IO.Put ("? ");
         end;
      end loop;
   end;

end Cistercian_Numerals;
