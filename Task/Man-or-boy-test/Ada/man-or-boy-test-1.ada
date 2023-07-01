with Ada.Text_IO;  use Ada.Text_IO;

procedure Man_Or_Boy is
   function Zero return Integer is begin return  0; end Zero;
   function One return Integer  is begin return  1; end One;
   function Neg return Integer  is begin return -1; end Neg;

   function A
            (  K : Integer;
               X1, X2, X3, X4, X5 : access function return Integer
            )  return Integer is
      M : Integer := K; -- K is read-only in Ada. Here is a mutable copy of
      function B return Integer is
      begin
         M := M - 1;
         return A (M, B'Access, X1, X2, X3, X4);
      end B;
   begin
      if M <= 0 then
         return X4.all + X5.all;
      else
         return B;
      end if;
   end A;
begin
   Put_Line
   (  Integer'Image
       (  A
          (  10,
             One'Access, -- Returns  1
             Neg'Access, -- Returns -1
             Neg'Access, -- Returns -1
             One'Access, -- Returns  1
             Zero'Access -- Returns  0
   )  )  );
end Man_Or_Boy;
