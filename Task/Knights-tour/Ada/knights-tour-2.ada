with Ada.Text_IO, Ada.Integer_Text_IO;

package body Knights_Tour is


   type Pair is array(1..2) of Integer;
   type Pair_Array is array (Positive range <>) of Pair;

   Pairs: constant Pair_Array (1..8)
     := ((-2,1),(-1,2),(1,2),(2,1),(2,-1),(1,-2),(-1,-2),(-2,-1));
   -- places for the night to go (relative to the current position)

   function Count_Moves(Board: Tour) return Natural is
      N: Natural := 0;
   begin
      for I in Index loop
	 for J in Index loop
	    if Board(I,J) < Natural'Last then
	       N := N + 1;
	    end if;
	 end loop;
      end loop;
      return N;
   end Count_Moves;

   function Get_Tour(Start_X, Start_Y: Index; Scene: Tour := Empty)
		    return Tour is
      Done: Boolean;
      Move_Count: Natural := Count_Moves(Scene);
      Visited: Tour;

      -- Visited(I, J) = 0: not yet visited
      -- Visited(I, J) = K: visited at the k-th move
      -- Visited(I, J) = Integer'Last: never visit

      procedure Visit(X, Y: Index; Move_Number: Positive; Found: out Boolean) is
         XX, YY: Integer;
      begin
         Found := False;
         Visited(X, Y) := Move_Number;
         if Move_Number = Move_Count then
            Found := True;
         else
            for P in Pairs'Range loop
               XX := X + Pairs(P)(1);
               YY := Y + Pairs(P)(2);
               if (XX in Index) and then (YY in Index)
                                and then Visited(XX, YY) = 0 then
                  Visit(XX, YY, Move_Number+1, Found); -- recursion
                  if Found then
                     return; -- no need to search further
                  end if;
               end if;
            end loop;
            Visited(X, Y) := 0; -- undo previous mark
         end if;
      end Visit;

   begin
      Visited := Scene;
      Visit(Start_X, Start_Y, 1, Done);
      if not Done then
         Visited := Scene;
      end if;
      return Visited;
   end Get_Tour;

   procedure Tour_IO(The_Tour: Tour; Width: Natural := 4) is
   begin
      for I in Index loop
         for J in Index loop
	    if The_Tour(I, J) < Integer'Last then
	       Ada.Integer_Text_IO.Put(The_Tour(I, J), Width);
	    else
	       for W in 1 .. Width-1 loop
		  Ada.Text_IO.Put(" ");
	       end loop;
	       Ada.Text_IO.Put("-"); -- deliberately not visited
	    end if;
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Tour_IO;

end Knights_Tour;
