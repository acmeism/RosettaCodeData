with Ada.Text_IO; use Ada.Text_IO;
with Ada.Complex_Text_IO; use Ada.Complex_Text_IO;
with Ada.Numerics.Complex_Types; use Ada.Numerics.Complex_Types;
with Ada.Numerics.Complex_Arrays; use Ada.Numerics.Complex_Arrays;
procedure ConTrans is
   subtype CM is Complex_Matrix;
   S2O2 : constant Float := 0.7071067811865;

   procedure Print (mat : CM) is begin
      for row in mat'Range(1) loop for col in mat'Range(2) loop
         Put(mat(row,col), Exp=>0, Aft=>4);
      end loop; New_Line; end loop;
   end Print;

   function almostzero(mat : CM; tol : Float) return Boolean is begin
      for row in mat'Range(1) loop for col in mat'Range(2) loop
         if abs(mat(row,col)) > tol then return False; end if;
      end loop; end loop;
      return True;
   end almostzero;

   procedure Examine (mat : CM) is
      CT : CM := Conjugate (Transpose(mat));
      isherm, isnorm, isunit : Boolean;
   begin
      isherm := almostzero(mat-CT, 1.0e-6);
      isnorm := almostzero(mat*CT-CT*mat, 1.0e-6);
      isunit := almostzero(CT-Inverse(mat), 1.0e-6);
      Print(mat);
      Put_Line("Conjugate transpose:"); Print(CT);
      Put_Line("Hermitian?: " & isherm'Img);
      Put_Line("Normal?: " & isnorm'Img);
      Put_Line("Unitary?: " & isunit'Img);
   end Examine;

   hmat : CM := ((3.0+0.0*i, 2.0+1.0*i), (2.0-1.0*i, 1.0+0.0*i));
   nmat : CM := ((1.0+0.0*i, 1.0+0.0*i, 0.0+0.0*i),
                 (0.0+0.0*i, 1.0+0.0*i, 1.0+0.0*i),
                 (1.0+0.0*i, 0.0+0.0*i, 1.0+0.0*i));
   umat : CM := ((S2O2+0.0*i, S2O2+0.0*i, 0.0+0.0*i),
                 (0.0+S2O2*i, 0.0-S2O2*i, 0.0+0.0*i),
                 (0.0+0.0*i, 0.0+0.0*i, 0.0+1.0*i));
begin
   Put_Line("hmat:"); Examine(hmat); New_Line;
   Put_Line("nmat:"); Examine(nmat); New_Line;
   Put_Line("umat:"); Examine(umat);
end ConTrans;
