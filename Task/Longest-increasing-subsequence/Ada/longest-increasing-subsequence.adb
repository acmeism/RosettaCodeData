with Ada.Text_IO;

procedure Longest_Increasing_Subsequence is
   type Sequence is array (Positive range <>) of Integer;

   Seq1 : constant Sequence :=
     (3, 2, 6, 4, 5, 1);
   Seq2 : constant Sequence :=
     (0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15);

   function Lis (Seq : Sequence) return Sequence is
      Best : Sequence (Seq'Range) := (others => 1);
      Pred : Sequence (Seq'Range) := (others => 0);
      Best_Idx, Max_Len : Natural := 0;
   begin
      --  Calculate LIS length for every end point
      for I in Seq'Range loop
         for J in 1 .. I - 1 loop
            if Seq (J) < Seq (I) and then
               Best (I) < 1 + Best (J) then
               Best (I) := 1 + Best (J);
               Pred (I) := J;
            end if;
         end loop;
      end loop;

      --  Find tail of global LIS
      for I in Best'Range loop
         if Best (I) > Max_Len then
            Best_Idx := I;
            Max_Len := Best (I);
         end if;
      end loop;

      --  Trace sequence
      declare
         Lis : Sequence (1 .. Max_Len);
      begin
         for I in reverse 1 .. Max_Len loop
            Lis (I) := Seq (Best_Idx);
            Best_Idx := Pred (Best_Idx);
         end loop;

         return Lis;
      end;
   end Lis;

begin
   Ada.Text_IO.Put_Line (Lis (Seq1)'Image);
   Ada.Text_IO.Put_Line (Lis (Seq2)'Image);
end Longest_Increasing_Subsequence;
