with Ada.Containers.Vectors;
with Ada.Numerics.Discrete_Random;
with Ada.Text_Io;

procedure Mutations is

   Width : constant := 60;

   type Nucleotide_Type is (A, C, G, T);
   type Operation_Type is (Delete, Insert, Swap);
   type Position_Type is new Natural;

   package Position_Io   is new Ada.Text_Io.Integer_Io (Position_Type);
   package Nucleotide_Io is new Ada.Text_Io.Enumeration_Io (Nucleotide_Type);
   package Operation_Io  is new Ada.Text_Io.Enumeration_Io (Operation_Type);

   use Ada.Text_Io, Position_Io, Nucleotide_Io, Operation_Io;

   package Sequence_Vectors is new Ada.Containers.Vectors (Index_Type   => Position_Type,
                                                           Element_Type => Nucleotide_Type);
   package Nucleotide_Generators is new Ada.Numerics.Discrete_Random (Result_Subtype => Nucleotide_Type);
   package Operation_Generators  is new Ada.Numerics.Discrete_Random (Result_Subtype => Operation_Type);

   procedure Pretty_Print (Sequence : Sequence_Vectors.Vector) is
      First : Position_Type := Sequence.First_Index;
      Last  : Position_Type;
      Count : array (Nucleotide_Type) of Natural := (others  => 0);
   begin
      Last := Position_Type'Min (First + Width - 1,
                                 Sequence.Last_Index);
      loop
         Position_Io.Put (First, Width => 4);
         Put (": ");
         for N in First .. Last loop
            declare
               Nucleotide : Nucleotide_Type renames Sequence (N);
            begin
               Put (Nucleotide);
               Count (Nucleotide) := Count (Nucleotide) + 1;
            end;
         end loop;
         New_Line;
         exit when Last = Sequence.Last_Index;
         First := Last + 1;
         Last  := Position_Type'Min (First + Width - 1,
                                     Sequence.Last_Index);
      end loop;

      for N in Count'Range loop
         Put ("Count of "); Put (N); Put (" is "); Put (Natural'Image (Count (N))); New_Line;
      end loop;

   end Pretty_Print;

   function Random_Position (First, Last : Position_Type) return Position_Type is
      subtype Position_Range is Position_Type range First .. Last;
      package Position_Generators is new Ada.Numerics.Discrete_Random (Result_Subtype => Position_Range);
      Generator : Position_Generators.Generator;
   begin
      Position_Generators.Reset (Generator);
      return Position_Generators.Random (Generator);
   end Random_Position;

   Nucleotide_Generator : Nucleotide_Generators.Generator;
   Operation_Generator  : Operation_Generators.Generator;

   Sequence   : Sequence_Vectors.Vector;
   Position   : Position_Type;
   Nucleotide : Nucleotide_Type;
   Operation  : Operation_Type;
begin
   Nucleotide_Generators.Reset (Nucleotide_Generator);
   Operation_Generators.Reset (Operation_Generator);

   for A in 1 .. 200 loop
      Sequence.Append (Nucleotide_Generators.Random (Nucleotide_Generator));
   end loop;

   Put_Line ("Initial sequence:");
   Pretty_Print (Sequence);
   New_Line;

   Put_Line ("Mutations:");
   for Mutate in 1 .. 10 loop

      Operation := Operation_Generators.Random (Operation_Generator);
      case Operation is

         when Delete =>
            Position := Random_Position (Sequence.First_Index, Sequence.Last_Index);
            Sequence.Delete (Index => Position);
            Put (Operation); Put (" at position "); Put (Position, Width => 0); New_Line;

         when Insert =>
            Position   := Random_Position (Sequence.First_Index, Sequence.Last_Index + 1);
            Nucleotide := Nucleotide_Generators.Random (Nucleotide_Generator);
            Sequence.Insert (Before   => Position,
                             New_Item => Nucleotide);
            Put (Operation); Put (" "); Put (Nucleotide); Put (" at position ");
            Put (Position, Width => 0); New_Line;

         when Swap =>
            Position   := Random_Position (Sequence.First_Index, Sequence.Last_Index);
            Nucleotide := Nucleotide_Generators.Random (Nucleotide_Generator);
            Sequence.Replace_Element (Index    => Position,
                                      New_Item => Nucleotide);
            Put (Operation); Put (" at position "); Put (Position, Width => 0);
            Put (" to "); Put (Nucleotide); New_Line;

      end case;
   end loop;

   New_Line;
   Put_Line ("Mutated sequence:");
   Pretty_Print (Sequence);

end Mutations;
