generic -- child of a generic package must be a generic unit
package S_Expr.Parser is

   function Parse(Input: String) return List_Of_Data;
   -- the result of a parse process is always a list of expressions

end S_Expr.Parser;
