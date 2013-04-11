with Ada.Text_IO;
procedure Hamming is
   generic
      type Int_Type is private;
      Zero  : Int_Type;
      One   : Int_Type;
      Two   : Int_Type;
      Three : Int_Type;
      Five  : Int_Type;
      with function "mod" (Left, Right : Int_Type) return Int_Type is <>;
      with function "/"   (Left, Right : Int_Type) return Int_Type is <>;
      with function "+"   (Left, Right : Int_Type) return Int_Type is <>;
   function Get_Hamming (Position : Positive) return Int_Type;

   function Get_Hamming (Position : Positive) return Int_Type is
      function Is_Hamming (Number : Int_Type) return Boolean is
         Temporary : Int_Type := Number;
      begin
         while Temporary mod Two = Zero loop
            Temporary := Temporary / Two;
         end loop;
         while Temporary mod Three = Zero loop
            Temporary := Temporary / Three;
         end loop;
         while Temporary mod Five = Zero loop
            Temporary := Temporary / Five;
         end loop;
         return Temporary = One;
      end Is_Hamming;
      Result   : Int_Type := One;
      Previous : Positive := 1;
   begin
      while Previous /= Position loop
         Result := Result + One;
         if Is_Hamming (Result) then
            Previous := Previous + 1;
         end if;
      end loop;
      return Result;
   end Get_Hamming;

   -- up to 2**32 - 1
   function Integer_Get_Hamming is new Get_Hamming
      (Int_Type => Integer,
       Zero     => 0,
       One      => 1,
       Two      => 2,
       Three    => 3,
       Five     => 5);

   -- up to 2**64 - 1
   function Long_Long_Integer_Get_Hamming is new Get_Hamming
      (Int_Type => Long_Long_Integer,
       Zero     => 0,
       One      => 1,
       Two      => 2,
       Three    => 3,
       Five     => 5);
begin
   Ada.Text_IO.Put ("1) First 20 Hamming numbers: ");
   for I in 1 .. 20 loop
      Ada.Text_IO.Put (Integer'Image (Integer_Get_Hamming (I)));
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("2) 1_691st Hamming number: " &
      Integer'Image (Integer_Get_Hamming (1_691)));
   -- even Long_Long_Integer overflows here
   Ada.Text_IO.Put_Line ("3) 1_000_000st Hamming number: " &
      Long_Long_Integer'Image (Long_Long_Integer_Get_Hamming (1_000_000)));
end Hamming;
