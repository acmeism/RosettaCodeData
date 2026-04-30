with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;      use Ada.Strings.Fixed;

procedure Range_Extraction is
   type Sequence is array (Positive range <>) of Integer;
   function Image (S : Sequence) return String is
      Result : Unbounded_String;
      From   : Integer;
      procedure Flush (To : Integer) is
      begin
         if Length (Result) > 0 then
            Append (Result, ',');
         end if;
         Append (Result, Trim (Integer'Image (From), Ada.Strings.Left));
         if From < To then
            if From+1 = To then
               Append (Result, ',');
            else
               Append (Result, '-');
            end if;
            Append (Result, Trim (Integer'Image (To), Ada.Strings.Left));
         end if;
      end Flush;
   begin
      if S'Length > 0 then
         From := S (S'First);
         for I in S'First + 1..S'Last loop
            if S (I - 1) + 1 /= S (I) then
               Flush (S (I - 1));
               From := S (I);
            end if;
         end loop;
         Flush (S (S'Last));
      end if;
      return To_String (Result);
   end Image;
begin
   Put_Line
     (  Image
          (  (  0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
                15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
                37, 38, 39
             )  )  );
end Range_Extraction;
