with S_Expr.Parser, Ada.Text_IO;

procedure Test_S_Expr is

   procedure Put_Line(Indention: Natural; Line: String) is
   begin
      for I in 1 .. 3*Indention loop
         Ada.Text_IO.Put(" ");
      end loop;
      Ada.Text_IO.Put_Line(Line);
   end Put_Line;

   package S_Exp is new S_Expr(Put_Line);
   package S_Par is new S_Exp.Parser;

   Input: String := "((data ""quoted data"" 123 4.5)" &
                    "(data (!@# (4.5) ""(more"" ""data)"")))";
   Expression_List: S_Exp.List_Of_Data := S_Par.Parse(Input);

begin
   Expression_List.First.Print(Indention => 0);
   -- Parse will output a list of S-Expressions. We need the first Expression.
end Test_S_Expr;
