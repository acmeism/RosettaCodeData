with String_Vectors, Ada.Text_IO, Ada.Command_Line;

procedure Semordnilap is

   function Backward(S: String) return String is
   begin
      if S'Length < 2 then
         return S;
      else
         return (S(S'Last) & Backward(S(S'First+1 .. S'Last-1)) & S(S'First));
      end if;
   end Backward;

   W: String_Vectors.Vec := String_Vectors.Read(Ada.Command_Line.Argument(1));

   Semi_Counter: Natural := 0;

begin
   for I in W.First_Index .. W.Last_Index loop
      if W.Element(I) /= Backward(W.Element(I)) and then
        W.Is_In(Backward(W.Element(I)), W.First_Index, I) then
         Semi_Counter := Semi_Counter + 1;
         if Semi_Counter <= 5 then
            Ada.Text_IO.Put_Line(W.Element(I) & " - " & Backward(W.Element(I)));
         end if;
      end if;
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put("pairs found:" & Integer'Image(Semi_Counter));
end Semordnilap;
