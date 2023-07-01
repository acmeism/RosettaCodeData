generic
   Size: Integer;
package Knights_Tour is

   subtype Index is Integer range 1 .. Size;
   type Tour is array  (Index, Index) of Natural;
   Empty: Tour := (others => (others => 0));

   function Get_Tour(Start_X, Start_Y: Index; Scene: Tour := Empty) return Tour;
   -- finds tour via backtracking
   -- either no tour has been found, i.e., Get_Tour returns Scene
   -- or the Result(X,Y)=K if and only if I,J is visited at the K-th move
   -- for all X, Y, Scene(X,Y) must be either 0 or Natural'Last,
   --   where Scene(X,Y)=Natural'Last means "don't visit coordiates (X,Y)!"

   function Count_Moves(Board: Tour) return Natural;
   -- counts the number of possible moves, i.e., the number of 0's on the board

   procedure Tour_IO(The_Tour: Tour; Width: Natural := 4);
   -- writes The_Tour to the output using Ada.Text_IO;

end Knights_Tour;
