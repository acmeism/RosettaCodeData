with Ada.Text_IO, Bonacci;

procedure Test_Bonacci is

   procedure Print(Name: String; S: Bonacci.Sequence) is
   begin
      Ada.Text_IO.Put(Name & "(");
      for I in S'First .. S'Last-1 loop
         Ada.Text_IO.Put(Integer'Image(S(I)) & ",");
      end loop;
      Ada.Text_IO.Put_Line(Integer'Image(S(S'Last)) & " )");
   end Print;

begin
   Print("Fibonacci:   ", Bonacci.Generate(Bonacci.Start_Fibonacci));
   Print("Tribonacci:  ", Bonacci.Generate(Bonacci.Start_Tribonacci));
   Print("Tetranacci:  ", Bonacci.Generate(Bonacci.Start_Tetranacci));
   Print("Lucas:       ", Bonacci.Generate(Bonacci.Start_Lucas));
   Print("Decanacci:   ",
         Bonacci.Generate((1, 1, 2, 4, 8, 16, 32, 64, 128, 256), 15));
end Test_Bonacci;
