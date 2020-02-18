with Ada.Text_IO, Generic_Divisors;

procedure ADB_Classification is
   function Same(P: Positive) return Positive is (P);
   package Divisor_Sum is new Generic_Divisors
     (Result_Type => Natural, None => 0, One => Same, Add =>  "+");

   type Class_Type is (Deficient, Perfect, Abundant);

   function Class(D_Sum, N: Natural) return Class_Type is
      (if D_Sum < N then Deficient
       elsif D_Sum = N then Perfect
       else Abundant);

   Cls: Class_Type;
   Results: array (Class_Type) of Natural := (others => 0);

   package NIO is new Ada.Text_IO.Integer_IO(Natural);
   package CIO is new Ada.Text_IO.Enumeration_IO(Class_Type);
begin
   for N in 1 .. 20_000 loop
      Cls := Class(Divisor_Sum.Process(N), N);
      Results(Cls) := Results(Cls)+1;
   end loop;
   for Class in Results'Range loop
      CIO.Put(Class, 12);
      NIO.Put(Results(Class), 8);
      Ada.Text_IO.New_Line;
   end loop;
   Ada.Text_IO.Put_Line("--------------------");
   Ada.Text_IO.Put("Sum         ");
   NIO.Put(Results(Deficient)+Results(Perfect)+Results(Abundant), 8);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line("====================");
end ADB_Classification;
