with Ada.Text_IO;

procedure Repeat_Example is

   procedure Repeat(P: access Procedure; Reps: Natural) is
   begin
      for I in 1 .. Reps loop
	 P.all; -- P points to a procedure, and P.all actually calls that procedure
      end loop;
   end Repeat;

   procedure Hello is
   begin
      Ada.Text_IO.Put("Hello! ");
   end Hello;

begin
   Repeat(Hello'Access, 3); -- Hello'Access points to the procedure Hello
end Repeat_Example;
