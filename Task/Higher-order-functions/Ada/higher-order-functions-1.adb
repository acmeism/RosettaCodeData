with Ada.Text_Io; use Ada.Text_Io;

procedure Subprogram_As_Argument is
   type Proc_Access is access procedure;

   procedure Second is
   begin
      Put_Line("Second Procedure");
   end Second;

   procedure First(Proc : Proc_Access) is
   begin
      Proc.all;
   end First;
begin
   First(Second'Access);
end Subprogram_As_Argument;
