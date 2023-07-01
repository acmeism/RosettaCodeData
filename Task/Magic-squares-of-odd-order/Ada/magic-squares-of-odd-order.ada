with Ada.Text_IO, Ada.Command_Line;

procedure Magic_Square is
   N: constant Positive := Positive'Value(Ada.Command_Line.Argument(1));

   subtype Constants is Natural range 1 .. N*N;
   package CIO is new Ada.Text_IO.Integer_IO(Constants);
   Undef: constant Natural := 0;

   subtype Index is Natural range 0 .. N-1;
   function Inc(I: Index) return Index is (if I = N-1 then 0 else I+1);
   function Dec(I: Index) return Index is (if I = 0 then N-1 else I-1);

   A: array(Index, Index) of Natural := (others => (others => Undef));
     -- initially undefined; at the end holding the magic square

   X: Index := 0; Y: Index := N/2; -- start position for the algorithm
begin
   for I in Constants loop -- write 1, 2, ..., N*N into the magic array
      A(X, Y) := I; -- write I into the magic array
      if A(Dec(X), Inc(Y)) = Undef then
	 X := Dec(X); Y := Inc(Y); -- go right-up
      else
	 X := Inc(X); -- go down
      end if;
   end loop;

   for Row in Index loop -- output the magic array
      for Collumn in Index loop
	 CIO.Put(A(Row, Collumn),
		 Width => (if N*N < 10 then 2 elsif N*N < 100 then 3 else 4));
      end loop;
      Ada.Text_IO.New_Line;
   end loop;
end Magic_Square;
