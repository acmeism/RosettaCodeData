with Ada.Text_IO, Hofstadter_Figure_Figure;

procedure Test_HSS is

   use Hofstadter_Figure_Figure;

   A: array(1 .. 1000) of Boolean := (others => False);
   J: Positive;

begin
   for I in 1 .. 10 loop
      Ada.Text_IO.Put(Integer'Image(FFR(I)));
   end loop;
   Ada.Text_IO.New_Line;

   for I in 1 .. 40 loop
      J := FFR(I);
      if A(J) then
         raise Program_Error with Positive'Image(J) & " used twice";
      end if;
      A(J) := True;
   end loop;

   for I in 1 .. 960 loop
      J := FFS(I);
      if A(J) then
         raise Program_Error with Positive'Image(J) & " used twice";
      end if;
      A(J) := True;
   end loop;

   for I in A'Range loop
      if not A(I) then raise Program_Error with Positive'Image(I) & " unused";
      end if;
   end loop;
   Ada.Text_IO.Put_Line("Test Passed: No overlap between FFR(I) and FFS(J)");

exception
   when Program_Error => Ada.Text_IO.Put_Line("Test Failed"); raise;
end Test_HSS;
