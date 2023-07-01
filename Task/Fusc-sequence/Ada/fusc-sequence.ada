with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Show_Fusc is

   generic
      Precalculate : Natural;
   package Fusc_Sequences is
      function Fusc (N : in Natural) return Natural;
   end Fusc_Sequences;

   package body Fusc_Sequences is

      Precalculated_Fusc : array (0 .. Precalculate) of Natural;

      function Fusc_Slow (N : in Natural) return Natural is
      begin
         if N = 0 or N = 1 then
            return N;
         elsif N mod 2 = 0 then
            return Fusc_Slow (N / 2);
         else
            return Fusc_Slow ((N - 1) / 2) + Fusc_Slow ((N + 1) / 2);
         end if;
      end Fusc_Slow;

      function Fusc (N : in Natural) return Natural is
      begin
         if N <= Precalculate then
            return Precalculated_Fusc (N);
         elsif N mod 2 = 0 then
            return Fusc (N / 2);
         else
            return Fusc ((N - 1) / 2) + Fusc ((N + 1) / 2);
         end if;
      end Fusc;

   begin
      for N in Precalculated_Fusc'Range loop
         Precalculated_Fusc (N) := Fusc_Slow (N);
      end loop;
   end Fusc_Sequences;


   package Fusc_Sequence is
      new Fusc_Sequences (Precalculate => 200_000);

   function Fusc (N : in Natural) return Natural
     renames Fusc_Sequence.Fusc;


   procedure Print_Small_Fuscs is
      use Ada.Text_IO;
   begin
      Put_Line ("First 61 numbers in the fusc sequence:");
      for N in 0 .. 60 loop
         Put (Fusc (N)'Image);
         Put (" ");
      end loop;
      New_Line;
   end Print_Small_Fuscs;


   procedure Print_Large_Fuscs (High : in Natural) is
      use Ada.Text_IO;
      use Ada.Integer_Text_IO;
      subtype N_Range is Natural range Natural'First .. High;
      F       : Natural;
      Len     : Natural;
      Max_Len : Natural := 0;
      Placeholder : String := "       n      fusc(n)";
      Image_N     : String renames Placeholder (1  .. 8);
      Image_Fusc  : String renames Placeholder (10 .. Placeholder'Last);
   begin
      New_Line;
      Put_Line ("Printing all largest Fusc numbers upto " & High'Image);
      Put_Line (Placeholder);

      for N in N_Range loop
         F   := Fusc (N);
         Len := F'Image'Length;

          if Len > Max_Len then
             Max_Len := Len;
             Put (Image_N,    N);
             Put (Image_Fusc, F);
             Put (Placeholder);
             New_Line;
          end if;
       end loop;
   end Print_Large_Fuscs;

begin
   Print_Small_Fuscs;
   Print_Large_Fuscs (High => 20_000_000);
end Show_Fusc;
