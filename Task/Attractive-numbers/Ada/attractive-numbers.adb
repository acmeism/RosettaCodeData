with Ada.Text_IO;

procedure Attractive_Numbers is

   function Is_Prime (N : in Natural) return Boolean is
      D : Natural := 5;
   begin
      if N < 2       then  return False;  end if;
      if N mod 2 = 0 then  return N = 2;  end if;
      if N mod 3 = 0 then  return N = 3;  end if;

      while D * D <= N loop
         if N mod D = 0 then  return False;  end if;
         D := D + 2;
         if N mod D = 0 then  return False;  end if;
         D := D + 4;
      end loop;
      return True;
   end Is_Prime;

   function Count_Prime_Factors (N : in Natural) return Natural is
      NC    : Natural := N;
      Count : Natural := 0;
      F     : Natural := 2;
   begin
      if NC = 1        then  return 0;  end if;
      if Is_Prime (NC) then  return 1;  end if;
      loop
         if NC mod F = 0 then
            Count := Count + 1;
            NC := NC / F;

            if NC = 1 then
               return Count;
            end if;

            if Is_Prime (NC) then F := NC; end if;
         elsif F >= 3 then
            F := F + 2;
         else
            F := 3;
         end if;
      end loop;
   end Count_Prime_Factors;

   procedure Show_Attractive (Max : in Natural)
   is
      use Ada.Text_IO;
      package Integer_IO is
         new Ada.Text_IO.Integer_IO (Integer);
      N     : Natural;
      Count : Natural := 0;
   begin
      Put_Line ("The attractive numbers up to and including " & Max'Image & " are:");
      for I in 1 .. Max loop
         N := Count_Prime_Factors (I);
         if Is_Prime (N) then
            Integer_IO.Put (I, Width => 5);
            Count := Count + 1;
            if Count mod 20 = 0 then New_Line; end if;
         end if;
      end loop;
   end Show_Attractive;

begin
   Show_Attractive (Max => 120);
end Attractive_Numbers;
