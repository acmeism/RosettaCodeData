generic
   Size: Integer;
package Knights_Tour is

   subtype Index is Integer range 1 .. Size;
   type Tour is array  (Index, Index) of Natural;

   function Get_Tour(Start_X, Start_Y: Index) return Tour;
   -- finds tour via backtracking
   -- either no tour has been found, (Get_Tour(X, Y)=0 for all X, Y in Index)
   -- or the Result(X,Y)=K if and only if I,J is visited at the K-th move

   procedure Tour_IO(The_Tour: Tour);
   -- writes The_Tour to the output using Ada.Text_IO;

end Knights_Tour;
