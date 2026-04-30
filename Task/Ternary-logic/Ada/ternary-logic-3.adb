with Ada.Text_IO, Logic;

procedure Test_Tri_Logic is

   use Logic;

   type F2 is access function(Left, Right: Ternary) return Ternary;
   type F1 is access function(Trit: Ternary) return Ternary;

   procedure Truth_Table(F: F1; Name: String) is
   begin
      Ada.Text_IO.Put_Line("X | " & Name & "(X)");
      for T in Ternary loop
         Ada.Text_IO.Put_Line(Image(T) & " |  " & Image(F(T)));
      end loop;
   end Truth_Table;

   procedure Truth_Table(F: F2; Name: String) is
   begin
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line("X | Y | " & Name & "(X,Y)");
      for X in Ternary loop
         for Y in Ternary loop
            Ada.Text_IO.Put_Line(Image(X) & " | " & Image(Y) & " |  " & Image(F(X,Y)));
         end loop;
      end loop;
   end Truth_Table;

begin
   Truth_Table(F => "not"'Access, Name => "Not");
   Truth_Table(F => "and"'Access, Name => "And");
   Truth_Table(F => "or"'Access, Name => "Or");
   Truth_Table(F => Equivalent'Access, Name => "Eq");
   Truth_Table(F => Implies'Access, Name => "Implies");
end Test_Tri_Logic;
