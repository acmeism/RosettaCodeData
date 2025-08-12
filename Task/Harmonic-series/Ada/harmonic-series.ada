with Ada.Text_IO;

procedure Harmonic_Numbers is
   type Harmonic_State is record
      N : Positive := 1;
      Hn : Float := 1.0;
   end record;

   procedure Iterate_Harmonics (Hs : in out Harmonic_State; Max_Steps : Positive := 1; Stop :  Float := Float'Last) is
   begin
      for I in 1 .. Max_Steps loop
         exit when Hs.Hn > Stop;
         Hs.N := Hs.N + 1;
         Hs.Hn := Hs.Hn + 1.0 / Float (Hs.N);
      end loop;
   end Iterate_Harmonics;

   procedure Show_First_Harmonics (N : Positive) is
      Hs : Harmonic_State;
   begin
      for I in 1 .. N loop
         Ada.Text_IO.Put_Line (Hs.N'Image & " => " & Hs.Hn'Image);
         Iterate_Harmonics (Hs);
      end loop;
   end Show_First_Harmonics;

   --  Assume Floats is in order
   type Floats is array (Positive range <>) of Float;
   procedure Show_Harmonics_Greater (Ns : Floats) is
      Hs : Harmonic_State;
   begin
      for I of Ns loop
         Iterate_Harmonics (Hs, Positive'Last, I);
         Ada.Text_IO.Put_Line (">" & I'Image & ":" & Hs.N'Image & " => " & Hs.Hn'Image);
      end loop;
   end Show_Harmonics_Greater;

begin
   Show_First_Harmonics (20);
   Show_Harmonics_Greater ((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0));
end Harmonic_Numbers;
