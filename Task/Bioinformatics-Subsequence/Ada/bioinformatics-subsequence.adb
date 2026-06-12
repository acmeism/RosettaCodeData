with Ada.Text_Io;
with Ada.Strings.Fixed;
with Ada.Numerics.Discrete_Random;

procedure Sub_Sequence is

   type Nucleotide is (A, C, G, T);

   function To_Character (N : Nucleotide) return Character
   is (case N is
          when A => 'A', when C => 'C',
          when G => 'G', when T => 'T');

   package Random_Nucleotide is new Ada.Numerics.Discrete_Random (Nucleotide);
   use Random_Nucleotide;

   package Position_Io is new Ada.Text_Io.Integer_Io (Natural);
   use Ada.Text_Io;

   procedure Put_Bases (Seq : String; Width : Positive) is
      First : Natural := Seq'First;
   begin
      while First < Seq'Last loop
         declare
            Last : constant Natural :=
              Natural'Min (First + Width - 1, Seq'Last);
         begin
            Position_Io.Put (First); Put ("..");
            Position_Io.Put (Last);  Put (" ");
            Put (Seq (First .. Last));
            New_Line;
            First := Last + 1;
         end;
      end loop;
   end Put_Bases;

   Gen       : Generator;
   Sequence  : String (1 .. 405);
   Substring : String (1 ..   4);
   Pos       : Natural := 0;
begin
   Position_Io.Default_Width := 3;

   Reset (Gen);

   Sequence  := (others => To_Character (Random (Gen)));
   Substring := (others => To_Character (Random (Gen)));

   Put_Line ("Search sequence:");
   Put_Bases (Sequence, Width => 50);
   New_Line;

   Put ("Substring to search: ");
   Put (Substring);
   New_Line;

   loop
      Pos := Ada.Strings.Fixed.Index (Sequence, Substring, Pos + 1);
      exit when Pos = 0;
      Put ("Found at position: ");
      Position_Io.Put (Pos); Put ("..");
      Position_Io.Put (Pos + Substring'Length - 1);
      New_Line;
   end loop;
end Sub_Sequence;
