with Ada.Text_IO;

procedure Exponentation_Order is
   use Ada.Text_IO;
begin
   --  Put_Line ("5**3**2   : " & Natural'(5**3**2)'Image);
   Put_Line ("(5**3)**2 : " & Natural'((5**3)**2)'Image);
   Put_Line ("5**(3**2) : " & Natural'(5**(3**2))'Image);
end Exponentation_Order;
