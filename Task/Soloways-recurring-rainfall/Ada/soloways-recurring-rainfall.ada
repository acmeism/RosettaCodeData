with Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;
with Ada.IO_Exceptions;

procedure RecurringRainfall is
   Current_Average : Float := 0.0;
   Current_Count : Integer := 0;
   Input_Integer : Integer;

   -- Recursively attempt to get a new integer
   function Get_Next_Input return Integer is
      Input_Integer : Integer;
      Clear_String : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Ada.Text_IO.Put("Enter rainfall int, 99999 to quit: ");
      Ada.Integer_Text_IO.Get(Input_Integer);
      return Input_Integer;
   exception
      when Ada.IO_Exceptions.Data_Error =>
         Ada.Text_IO.Put_Line("Invalid input");
         -- We need to call Get_Line to make sure we flush the kb buffer
         -- The pragma is to ignore the fact that we are not using the result
         pragma Warnings (Off, Clear_String);
         Clear_String := Ada.Text_IO.Unbounded_IO.Get_Line;
         -- Recursively call self -- it'll break when valid input is hit
         -- We disable the infinite recursion because we're intentionally
         -- doing this.  It will "break" when the user inputs valid input
         -- or kills the program
         pragma Warnings (Off, "infinite recursion");
         return Get_Next_Input;
         pragma Warnings (On, "infinite recursion");
   end Get_Next_Input;

begin
   loop
      Input_Integer := Get_Next_Input;
      exit when Input_Integer = 99999;

	  Current_Count := Current_Count + 1;
      Current_Average := Current_Average + (Float(1) / Float(Current_Count))*Float(Input_Integer) - (Float(1) / Float(Current_Count))*Current_Average;

      Ada.Text_IO.Put("New Average: ");
      Ada.Text_IO.Put_Line(Float'image(Current_Average));

   end loop;
end RecurringRainfall;
