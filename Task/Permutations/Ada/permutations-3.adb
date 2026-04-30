with Ada.Text_IO, Ada.Command_Line, Generic_Perm;

procedure Print_Perms is
   package CML renames Ada.Command_Line;
   package TIO renames Ada.Text_IO;
begin
   declare
      package Perms is new Generic_Perm(Positive'Value(CML.Argument(1)));
      P : Perms.Permutation;
      Done : Boolean := False;

      procedure Print(P: Perms.Permutation) is
      begin
         for I in P'Range loop
            TIO.Put (Perms.Element'Image (P (I)));
         end loop;
         TIO.New_Line;
      end Print;
   begin
      Perms.Set_To_First(P, Done);
      loop
         Print(P);
         exit when Done;
         Perms.Go_To_Next(P, Done);
      end loop;
   end;
exception
   when Constraint_Error
     => TIO.Put_Line ("*** Error: enter one numerical argument n with n >= 1");
end Print_Perms;
