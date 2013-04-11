with Ada.Text_IO, Ada.Integer_Text_IO;

package body Knights_Tour is

   Visited: Tour;
   -- Visited(I, J)=0: Not yet visited
   -- Visited(I, J)=K: Visited during the k-th move

   type Pair is array(1..2) of Integer;
   type Pair_Array is array (Positive range <>) of Pair;

   Pairs: constant Pair_Array (1..8)
     := ((-2,1),(-1,2),(1,2),(2,1),(2,-1),(1,-2),(-1,-2),(-2,-1));
   -- possible places to visit if Done

   function Get_Tour(Start_X, Start_Y: Index) return Tour is

      procedure Visit(X, Y: Index; Move_Number: Positive; Found: out Boolean) is
         XX, YY: Integer;
      begin
         Found := False;
         Visited(X, Y) := Move_Number;
         if Move_Number = Integer(Index'Last * Index'Last) then
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

      Done: Boolean;
   begin
      Visited := (others => (others => 0));
      Visit(Start_X, Start_Y, 1, Done);
      if not Done then
         Visited := (others => (others => 0));
      end if;
      return Visited;
   end Get_Tour;

   procedure Tour_IO(The_Tour: Tour) is
   begin
      if The_Tour(1, 1) /= 0 then
      for I in Index loop
         for J in Index loop
            Ada.Integer_Text_IO.Put(The_Tour(I, J), 4);
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
      else
         Ada.Text_IO.Put_Line("No Solution");
      end if;
   end Tour_IO;

end Knights_Tour;
