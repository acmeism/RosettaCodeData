with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO;            use Ada.Text_IO;
with Generic_Stack;

procedure RPN_to_Infix is
   -- The code above
begin
   Put_Line ("3 4 2 * 1 5 - 2 3 ^ ^ / + = ");
   Put_Line (Convert ("3 4 2 * 1 5 - 2 3 ^ ^ / +"));
   Put_Line ("1 2 + 3 4 + ^ 5 6 + ^ = ");
   Put_Line (Convert ("1 2 + 3 4 + ^ 5 6 + ^"));
end RPN_to_Infix;
