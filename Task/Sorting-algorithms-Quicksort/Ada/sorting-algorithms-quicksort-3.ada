with Sort;
with Ada.Text_Io;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure Sort_Test is
   type Days is (Mon, Tue, Wed, Thu, Fri, Sat, Sun);
   type Sales is array(Days range <>) of Float;
   procedure Sort_Days is new Sort(Float, Days, Sales);

   procedure Print(Item : Sales) is
   begin
      for I in Item'range loop
         Put(Item => Item(I), Fore => 5, Aft => 2, Exp => 0);
      end loop;
   end Print;

   Weekly_Sales : Sales := (Mon => 300.0,
      Tue => 700.0,
      Wed => 800.0,
      Thu => 500.0,
      Fri => 200.0,
      Sat => 100.0,
      Sun => 900.0);

begin

   Print(Weekly_Sales);
   Ada.Text_Io.New_Line(2);
   Sort_Days(Weekly_Sales);
   Print(Weekly_Sales);

end Sort_Test;
