with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO, Ada.Numerics.Long_Elementary_Functions,
  Ada.Long_Float_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO, Ada.Numerics.Long_Elementary_Functions,
  Ada.Long_Float_Text_IO;

procedure Fibonacci_Words is

   function Entropy (S : Unbounded_String) return Long_Float is
      CF    : array (Character) of Natural := (others => 0);
      Len   : constant Natural             := Length (S);
      H     : Long_Float                   := 0.0;
      Ratio : Long_Float;
   begin
      for I in 1 .. Len loop
         CF (Element (S, I)) := CF (Element (S, I)) + 1;
      end loop;
      for C in Character loop
         Ratio := Long_Float (CF (C)) / Long_Float (Len);
         if Ratio /= 0.0 then
            H := H - Ratio * Log (Ratio, 2.0);
         end if;
      end loop;
      return H;
   end Entropy;

   procedure Print_Line (Word : Unbounded_String; Number : Integer) is
   begin
      Put (Number, 4);
      Put (Length (Word), 10);
      Put (Entropy (Word), 2, 15, 0);
      if Length (Word) < 35 then
         Put ("  " & Word);
      end if;
      New_Line;
   end Print_Line;

   First, Second, Result : Unbounded_String;

begin
   Set_Col (4);  Put ("N");
   Set_Col (9);  Put ("Length");
   Set_Col (16); Put ("Entropy");
   Set_Col (35); Put_Line ("Word");
   First := To_Unbounded_String ("1");
   Print_Line (First, 1);
   Second := To_Unbounded_String ("0");
   Print_Line (Second, 2);
   for N in 3 .. 37 loop
      Result := Second & First;
      Print_Line (Result, N);
      First  := Second;
      Second := Result;
   end loop;
end Fibonacci_Words;
