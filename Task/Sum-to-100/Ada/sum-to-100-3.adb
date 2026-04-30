with Sum_To;

procedure Sum_To_100 is

   procedure Print_100 is new Sum_To.Print(100, "=");
   procedure Eval_100 is new Sum_To.Eval(Print_100);

begin
   Eval_100;
end Sum_To_100;
