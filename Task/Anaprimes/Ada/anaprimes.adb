with Ada.Containers;
with Ada.Containers.Generic_Constrained_Array_Sort;
with Ada.Containers.Vectors;
with Ada.Containers.Hashed_Maps;
with Ada.Strings.Hash;
with Ada.Text_IO;

procedure Anaprimes is
   Sieve_Order : constant Positive := 6;
   Sieve_Limit : constant Positive := 10 ** Sieve_Order;
   type Sieve is array (2 .. Sieve_Limit) of Boolean;
   Prime_Sieve : Sieve := (others => True);

   procedure Precompute_Prime_Sieve is
   begin
      For I in Prime_Sieve'First .. Prime_Sieve'Last loop
         if (Prime_Sieve (I)) then
            for J in I .. Prime_Sieve'Last / I loop
               Prime_Sieve (I * J) := False;
            end loop;
         end if;
      end loop;
   end Precompute_Prime_Sieve;

   procedure Show_Largest_Prime_Class (Digit_Length : Positive) is
      -- Don't panic. Just a little boilerplate to use our generics.
      subtype Key_Index is Positive range 1 .. Digit_Length;
      subtype Key is String (Key_Index);
      procedure Key_Sort is new Ada.Containers.Generic_Constrained_Array_Sort
        (Index_Type => Key_Index, Element_Type => Character, Array_Type => Key);
      package Positive_Vectors is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Positive);
      package String_Vector_Maps is new Ada.Containers.Hashed_Maps
        (Key_Type => Key, Element_Type => Positive_Vectors.Vector,
         Hash => Ada.Strings.Hash, Equivalent_Keys => "=", "=" => Positive_Vectors."=");
      K : Key;
      V : Positive_Vectors.Vector;
      M : String_Vector_Maps.Map;
      Len : Ada.Containers.Count_Type := 0;
      Max_Len : Ada.Containers.Count_Type := 0;
   begin
      for I in 10 ** (Digit_Length - 1) .. 10 ** Digit_Length loop
         if (Prime_Sieve (I)) then
            -- Skip the leading blank.
            K := I'Image (2 .. Digit_Length + 1);
            Key_Sort (K);
            if M.Contains (K) then
               -- This copies. Update_Element is too confusing.
               V := M.Element (K);
               V.Append (I);
               M.Replace (K, V);
               Len := Positive_Vectors.Length (V);
            else
               V := Positive_Vectors.Empty_Vector;
               V.Append (I);
               M.Insert (K, V);
            end if;

            -- This could be simpler with a "use" clause above, but I
            -- like fully qualified names.
            if Ada.Containers.">" (Len, Max_Len) then
               Max_Len := Len;
            end if;
         end if;
      end loop;

      Ada.Text_IO.Put_Line
        ("Largest prime class with " & Digit_Length'Image
         & " digits count " & Max_Len'Image);
      for V of M loop
         if Ada.Containers."=" (Positive_Vectors.Length (V), Max_Len) then
            Ada.Text_IO.Put_Line
              ("Minimum: " & V.First_Element'Image
               & ", Maximum: " & V.Last_Element'Image);
         end if;
      end loop;
   end Show_Largest_Prime_Class;

begin
   Precompute_Prime_Sieve;
   Show_Largest_Prime_Class (3);
   Show_Largest_Prime_Class (4);
   Show_Largest_Prime_Class (5);
   Show_Largest_Prime_Class (6);
end;
