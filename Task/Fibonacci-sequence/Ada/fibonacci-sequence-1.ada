with Ada.Text_IO, Ada.Command_Line;

procedure Fib is

   X: Positive := Positive'Value(Ada.Command_Line.Argument(1));

   function Fib(P: Positive) return Positive is
   begin
      if P <= 2 then
         return 1;
      else
         return Fib(P-1) + Fib(P-2);
      end if;
   end Fib;

begin
   Ada.Text_IO.Put("Fibonacci(" & Integer'Image(X) & " ) = ");
   Ada.Text_IO.Put_Line(Integer'Image(Fib(X)));
end Fib;
