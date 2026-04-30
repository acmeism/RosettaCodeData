with Ada.Text_IO, Ada.Strings.Fixed;

procedure Range_Extract is
   type Sequence is array (Positive range <>) of Integer;

   function Img(I: Integer) return String is -- the image of an Integer
   begin
      return
        Ada.Strings.Fixed.Trim(Integer'Image(I), Ada.Strings.Left);
   end Img;

   function Img(S: Sequence) return String is -- the image of a Sequence

      function X(S : Sequence) return String is -- recursive eXtract
         Idx: Positive := S'First;
      begin
         if S'Length = 0 then return
           ""; -- return nothing if Sequence is empty
         else
            while Idx < S'Last and then S(Idx+1) = S(Idx) + 1 loop
               Idx := Idx + 1;
            end loop;
            if Idx = S'First then return
              "," & Img(S(Idx)) & X(S(Idx+1 .. S'Last));
            elsif Idx = S'First+1 then return
              "," & Img(S(S'First)) & ',' & Img(S(Idx)) & X(S(Idx+1 .. S'Last));
            else return
              "," & Img(S(S'First)) & '-' & Img(S(Idx)) & X(S(Idx+1 .. S'Last));
            end if;
         end if;
      end X;

   begin -- function Img(S: Sequence) return String
      if S'Length = 0 then return
        "";
      else return
        Img(S(S'First)) & X(S(S'First+1 .. S'Last));
      end if;
   end Img;

begin -- main
   Ada.Text_IO.Put_Line(Img( ( 0,  1,  2,  4,  6,  7,  8, 11, 12, 14, 15, 16,
                               17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29,
                               30, 31, 32, 33, 35, 36, 37, 38, 39) ));
end Range_Extract;
