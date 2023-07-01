with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure Main is
   procedure print_range(start : integer; stop : integer; step : integer) is
      Num : Integer := start;
   begin
      Put("Range(" & start'Image & ", " & stop'image &
            ", " & step'image & ") => ");
      if stop < start then
         Put_Line("Error: stop must be no less than start!");
      elsif step not in positive then
         Put_Line("Error: increment must be greater than 0!");
      elsif start = stop then
         Put_Line(start'image);
      else
         while num <= stop loop
            Put(num'Image);
            num := num + step;
         end loop;
         New_Line;
      end if;
   end print_range;

   type test_record is record
      start   : integer;
      stop    : integer;
      step    : integer;
      comment : unbounded_string := null_unbounded_string;
   end record;

   tests : array(1..9) of test_record :=
     ( 1 => (-2, 2, 1, To_Unbounded_String("Normal")),
       2 => (-2, 2, 0, To_Unbounded_String("Zero increment")),
       3 => (-2, 2, -1, To_Unbounded_String("Increments away from stop value")),
       4 => (-2, 2, 10, To_Unbounded_String("First increment is beyond stop value")),
       5 => (2, -1, 1, To_Unbounded_String("Start more than stop: positive increment")),
       6 => (2, 2, 1, To_Unbounded_String("Start equal stop: positive increment")),
       7 => (2, 2, -1, To_Unbounded_String("Start equal stop: negative increment")),
       8 => (2, 2, 0, To_Unbounded_String("Start equal stop: zero increment")),
       9 => (0, 0, 0, To_Unbounded_String("Start equal stop equal zero: zero increment")));


begin
   for test of tests loop
      Put(Test.Comment); Put(" : ");
      print_range(test.start, test.stop, test.step);
      New_line;
   end loop;
end Main;
