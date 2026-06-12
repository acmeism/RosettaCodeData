-- Show command-line arguments
-- J. Carter     2023 Apr
-- The task is called "Parse command-line arguments", but as parsing requires attaching meaning to arguments, and the task
-- specification does not do so, showing them is all we can reasonably do

with Ada.Command_Line;
with Ada.Text_IO;

procedure Show_Args is
   -- Empty
begin -- Show_Args
   All_Args : for Arg in 1 .. Ada.Command_Line.Argument_Count loop
      Ada.Text_IO.Put_Line (Item => Arg'Image & ": " & Ada.Command_Line.Argument (Arg) );
   end loop All_Args;
end Show_Args;
