with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   procedure divisor_count_and_sum
     (n : Positive; divisor_count : out Natural; divisor_sum : out Natural)
   is
      I : Positive := 1;
      J : Natural;
   begin
      divisor_count := 0;
      divisor_sum   := 0;
      loop
         J := n / I;
         exit when J < I;
         if I * J = n then
            divisor_sum   := divisor_sum + I;
            divisor_count := divisor_count + 1;
            if I /= J then
               divisor_sum   := divisor_sum + J;
               divisor_count := divisor_count + 1;
            end if;
         end if;
         I := I + 1;
      end loop;
   end divisor_count_and_sum;

   arithmetic_count : Natural  := 0;
   composite_count  : Natural  := 0;
   div_count        : Natural;
   div_sum          : Natural;
   mean             : Natural;
   n                : Positive := 1;
begin

   while arithmetic_count <= 1_000_000 loop
      divisor_count_and_sum (n, div_count, div_sum);
      mean := div_sum / div_count;
      if mean * div_count = div_sum then
         arithmetic_count := arithmetic_count + 1;
         if div_count > 2 then
            composite_count := composite_count + 1;
         end if;
         if arithmetic_count <= 100 then
            Put (Item => n, Width => 4);
            if arithmetic_count mod 10 = 0 then
               New_Line;
            end if;
         end if;
         if arithmetic_count = 1_000 or else arithmetic_count = 10_000
           or else arithmetic_count = 100_000
           or else arithmetic_count = 1_000_000
         then
            New_Line;
            Put (Item => arithmetic_count, Width => 1);
            Put_Line ("th arithmetic number is" & n'Image);
            Put_Line
              ("Number of composite arithmetic numbers <=" & n'Image & ":" &
               composite_count'Image);
         end if;
      end if;
      n := n + 1;
   end loop;
end Main;
