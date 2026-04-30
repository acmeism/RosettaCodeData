with Ada.Text_IO, Ada.Containers.Vectors;

procedure Sequence is

   package Vectors is new
     Ada.Containers.Vectors(Index_Type => Positive, Element_Type => Positive);
   use type Vectors.Vector;

   type Sequence is record
      List: Vectors.Vector;
      Index: Positive;
      -- This implements some form of "lazy evaluation":
      --  + List holds the elements computed, so far, it is extended
      --    if the user tries to "Get" an element not yet computed;
      --  + Index is the location of the next element under consideration
   end record;

   function Initialize return Sequence is
      (List => (Vectors.Empty_Vector & 1 & 1), Index => 2);

   function Get(Seq: in out Sequence; Location: Positive) return Positive is
      -- returns the Location'th element of the sequence
      -- extends Seq.List (and then increases Seq.Index) if neccessary
      That: Positive := Seq.List.Element(Seq.Index);
      This: Positive := That + Seq.List.Element(Seq.Index-1);
   begin
      while Seq.List.Last_Index < Location loop
	 Seq.List := Seq.List & This & That;
	 Seq.Index := Seq.Index + 1;
      end loop;
      return Seq.List.Element(Location);
   end Get;

   S: Sequence := Initialize;
   J: Positive;

   use Ada.Text_IO;

begin
   -- show first fifteen members
   Put("First 15:");
   for I in 1 .. 15 loop
      Put(Integer'Image(Get(S, I)));
   end loop;
   New_Line;

   -- show the index where 1, 2, 3, ... first appear in the sequence
   for I in 1 .. 10 loop
      J := 1;
      while Get(S, J) /= I loop
	 J := J + 1;
      end loop;
      Put("First" & Integer'Image(I) & " at" & Integer'Image(J) & ";  ");
      if I mod 4 = 0 then
	 New_Line; -- otherwise, the output gets a bit too ugly
      end if;
   end loop;

   -- show the index where 100 first appears in the sequence
   J := 1;
   while Get(S, J) /= 100 loop
      J := J + 1;
   end loop;
   Put_Line("First 100 at" & Integer'Image(J) & ".");

   -- check GCDs
   declare
      function GCD (A, B : Integer) return Integer is
	 M : Integer := A;
	 N : Integer := B;
	 T : Integer;
      begin
	 while N /= 0 loop
	    T := M;
	    M := N;
	    N := T mod N;
	 end loop;
	 return M;
      end GCD;

      A, B: Positive;
   begin
      for I in 1 .. 999 loop
	 A := Get(S, I);
	 B := Get(S, I+1);
	 if GCD(A, B) /= 1 then
	    raise Constraint_Error;
	 end if;
      end loop;
      Put_Line("Correct: The first 999 consecutive pairs are relative prime!");
   exception
      when Constraint_Error => Put_Line("Some GCD > 1; this is wrong!!!") ;
   end;
end Sequence;
