declare
   type Int_Ptr is access all Integer;
   Ref : Int_Ptr;
   Var : aliased Integer := 3;
   Val : Integer := Var;
begin
   Ref := Var'Access; -- "Ref := Val'Access;" would be a syntax error
