with Ada.Text_IO;

procedure Van_Eck_Sequence is

   Sequence : array (Natural range 1 .. 1_000) of Natural;

   procedure Calculate_Sequence is
   begin
      Sequence (Sequence'First) := 0;
      for Index in Sequence'First .. Sequence'Last - 1 loop
         Sequence (Index + 1) := 0;
         for I in reverse Sequence'First .. Index - 1 loop
            if Sequence (I) = Sequence (Index) then
               Sequence (Index + 1) := Index - I;
               exit;
            end if;
         end loop;
      end loop;
   end Calculate_Sequence;

   procedure Show (First, Last : in Positive) is
      use Ada.Text_IO;
   begin
      Put ("Element" & First'Image & " .." & Last'Image & " of Van Eck sequence: ");
      for I in First .. Last loop
         Put (Sequence (I)'Image);
      end loop;
      New_Line;
   end Show;

begin
   Calculate_Sequence;
   Show (First =>   1, Last =>    10);
   Show (First => 991, Last => 1_000);
end Van_Eck_Sequence;
