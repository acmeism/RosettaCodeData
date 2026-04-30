with Ada.Text_IO;
with Ada.Containers.Hashed_Sets;

procedure Mian_Chowla_Sequence
is
   type Natural_Array is array(Positive range <>) of Natural;

   function Hash(P : in Positive) return Ada.Containers.Hash_Type is
   begin
      return Ada.Containers.Hash_Type(P);
   end Hash;

   package Positive_Sets is new Ada.Containers.Hashed_Sets(Positive, Hash, "=");

   function Mian_Chowla(N : in Positive) return Natural_Array
   is
      return_array : Natural_Array(1 .. N) := (others => 0);
      nth : Positive := 1;
      candidate : Positive := 1;
      seen : Positive_Sets.Set;
   begin
      while nth <= N loop
         declare
            sums : Positive_Sets.Set;
            terms : constant Natural_Array := return_array(1 .. nth-1) & candidate;
            found : Boolean := False;
         begin
            for term of terms loop
               if seen.Contains(term + candidate) then
                  found := True;
                  exit;
               else
                  sums.Insert(term + candidate);
               end if;
            end loop;

            if not found then
               return_array(nth) := candidate;
               seen.Union(sums);
               nth := nth + 1;
            end if;
            candidate := candidate + 1;
         end;
      end loop;
      return return_array;
   end Mian_Chowla;

   length : constant Positive := 100;
   sequence : constant Natural_Array(1 .. length) := Mian_Chowla(length);
begin
   Ada.Text_IO.Put_Line("Mian Chowla sequence first 30 terms :");
   for term of sequence(1 .. 30) loop
      Ada.Text_IO.Put(term'Img);
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line("Mian Chowla sequence terms 91 to 100 :");
   for term of sequence(91 .. 100) loop
      Ada.Text_IO.Put(term'Img);
   end loop;
end Mian_Chowla_Sequence;
