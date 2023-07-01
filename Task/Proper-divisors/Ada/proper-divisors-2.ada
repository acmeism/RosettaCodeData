with Ada.Text_IO, Ada.Containers.Generic_Array_Sort, Generic_Divisors;

procedure Proper_Divisors is

begin
   -- show the proper divisors of the numbers 1 to 10 inclusive.
   declare
      type Pos_Arr is array(Positive range <>) of Positive;
      subtype Single_Pos_Arr is Pos_Arr(1 .. 1);
      Empty: Pos_Arr(1 .. 0);

      function Arr(P: Positive) return Single_Pos_Arr is ((others => P));

      package Divisor_List is new Generic_Divisors
	(Result_Type => Pos_Arr, None => Empty, One => Arr, Add =>  "&");

      procedure Sort is new Ada.Containers.Generic_Array_Sort
	(Positive, Positive, Pos_Arr);
   begin
      for I in 1 .. 10 loop
	 declare
	    List: Pos_Arr := Divisor_List.Process(I);
	 begin
	    Ada.Text_IO.Put
	      (Positive'Image(I) & " has" &
		 Natural'Image(List'Length) & " proper divisors:");
	    Sort(List);
	    for Item of List loop
	       Ada.Text_IO.Put(Positive'Image(Item));
	    end loop;
	    Ada.Text_IO.New_Line;
	 end;
      end loop;
   end;

   -- find a number 1 .. 20,000 with the most proper divisors
   declare
      Number: Positive := 1;
      Number_Count: Natural := 0;
      Current_Count: Natural;

      function Cnt(P: Positive) return Positive is (1);

      package Divisor_Count is new Generic_Divisors
	(Result_Type => Natural, None => 0, One => Cnt, Add =>  "+");

   begin
      for Current in 1 .. 20_000 loop
	 Current_Count := Divisor_Count.Process(Current);
	 if Current_Count > Number_Count then
	    Number := Current;
	    Number_Count := Current_Count;
	 end if;
      end loop;
      Ada.Text_IO.Put_Line
	(Positive'Image(Number) & " has the maximum number of" &
	   Natural'Image(Number_Count) & " proper divisors.");
   end;
end Proper_Divisors;
