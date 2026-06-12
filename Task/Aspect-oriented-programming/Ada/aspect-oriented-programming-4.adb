with Ada.Text_IO; use Ada.Text_IO;

package body parent.child is

   function Add2 (X : in Integer) return Integer is
   begin
      Put_Line ("Added 2 to " & X'Image);
      return parent.Add2 (X);
   end Add2;

end parent.child;
