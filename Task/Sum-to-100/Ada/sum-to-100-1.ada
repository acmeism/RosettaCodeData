package Sum_To is

   generic
      with procedure Callback(Str: String; Int: Integer);
   procedure Eval;

   generic
      Number: Integer;
      with function Print_If(Sum, Number: Integer) return Boolean;
   procedure Print(S: String; Sum: Integer);

end Sum_To;
