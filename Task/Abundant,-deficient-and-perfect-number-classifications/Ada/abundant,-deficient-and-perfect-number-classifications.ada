with Ada.Text_IO, Generic_Divisors;

procedure ADB_Classification is
   function Same(P: Positive) return Positive is (P);

   package Divisor_Sum is new Generic_Divisors
     (Result_Type => Natural, None => 0, One => Same, Add =>  "+");

   type Class_Type is (Deficient, Perfect, Abundant);

   Results: array (Class_Type) of Natural := (others => 0);
   Sum: Natural;

   package NIO is new Ada.Text_IO.Integer_IO(Natural);
   package CIO is new Ada.Text_IO.Enumeration_IO(Class_Type);
begin
   for N in 1 .. 20_000 loop
      Sum := Divisor_Sum.Process(N);
      if Sum < N then
	 Results(Deficient) := Results(Deficient)+1;
      elsif Sum = N then
	 Results(Perfect) := Results(Perfect)+1;
      else
	 Results(Abundant) := Results(Abundant)+1;
      end if;
   end loop;
   Sum := 0;
   for Class in Results'Range loop
      CIO.Put(Class, 12);
      NIO.Put(Results(Class), 8);
      Ada.Text_IO.New_Line;
   end loop;
   Ada.Text_IO.Put_Line("--------------------");
   Ada.Text_IO.Put("Sum         ");
   NIO.Put(Sum, 8);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line("====================");
end ADB_Classification;
