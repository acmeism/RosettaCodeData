with Ada.Text_IO;

procedure Equilibrium is

   type Integer_Sequence is array (Positive range <>) of Integer;
   function Seq_Img (From : Integer_Sequence) return String is
   begin
      if From'First /= From'Last then
         return " " & Integer'Image (From (From'First)) &
            Seq_Img (From (From'First + 1 .. From'Last));
      else
         return " " & Integer'Image (From (From'First));
      end if;
   end Seq_Img;

   type Boolean_Sequence is array (Positive range <>) of Boolean;
   function Seq_Img (From : Boolean_Sequence) return String is
   begin
      if From'First > From'Last then
         return "";
      end if;
      if From (From'First) then
         return Integer'Image (From'First) &
            Seq_Img (From (From'First + 1 .. From'Last));
      else
         return Seq_Img (From (From'First + 1 .. From'Last));
      end if;
   end Seq_Img;

   function Get_Indices (From : Integer_Sequence) return Boolean_Sequence is
      Result : Boolean_Sequence (From'Range) := (others => False);
      Left_Sum, Right_Sum : Integer := 0;
   begin
      for Index in From'Range loop
         Right_Sum := Right_Sum + From (Index);
      end loop;
      for Index in From'Range loop
         Right_Sum := Right_Sum - From (Index);
         Result (Index) := Left_Sum = Right_Sum;
         Left_Sum  := Left_Sum  + From (Index);
      end loop;
      return Result;
   end Get_Indices;

   X1 : Integer_Sequence := (-7,  1, 5,  2, -4,  3, 0);
   X1_Result : Boolean_Sequence := Get_Indices (X1);
   X2 : Integer_Sequence := ( 2,  4, 6);
   X2_Result : Boolean_Sequence := Get_Indices (X2);
   X3 : Integer_Sequence := ( 2,  9, 2);
   X3_Result : Boolean_Sequence := Get_Indices (X3);
   X4 : Integer_Sequence := ( 1, -1, 1, -1,  1 ,-1, 1);
   X4_Result : Boolean_Sequence := Get_Indices (X4);

begin
   Ada.Text_IO.Put_Line ("Results:");
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("X1:" & Seq_Img (X1));
   Ada.Text_IO.Put_Line ("Eqs:" & Seq_Img (X1_Result));
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("X2:" & Seq_Img (X2));
   Ada.Text_IO.Put_Line ("Eqs:" & Seq_Img (X2_Result));
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("X3:" & Seq_Img (X3));
   Ada.Text_IO.Put_Line ("Eqs:" & Seq_Img (X3_Result));
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("X4:" & Seq_Img (X4));
   Ada.Text_IO.Put_Line ("Eqs:" & Seq_Img (X4_Result));
end Equilibrium;
