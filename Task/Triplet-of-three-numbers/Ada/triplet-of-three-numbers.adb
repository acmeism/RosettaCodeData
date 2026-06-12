with Ada.Text_Io;

procedure Triplets is

   Limit : constant := 5999;
   Prime : array (1 .. Limit + 5) of Boolean := (others => True);

   procedure Fill_Primes is
   begin
      Prime (1) := False;
      for N in 2 .. Limit loop
         if Prime (N) then
            for I in 2 .. Positive'Last loop
               exit when I * N not in Prime'Range;
               Prime (I * N) := False;
            end loop;
         end if;
      end loop;
   end Fill_Primes;

   function Is_Triplet (N : Natural) return Boolean is
   begin
      return
        Prime (N - 1) and then
        Prime (N + 3) and then
        Prime (N + 5);
   end Is_Triplet;

   package Natural_Io is new Ada.Text_Io.Integer_Io (Natural);
   use Ada.Text_Io, Natural_IO;
begin
   Natural_Io.Default_Width := 5;
   Fill_Primes;

   for N in 2 .. Limit loop
      if Is_Triplet (N) then
         Put (N, Width => 4);
         Put (":");
         Put (N - 1);
         Put (N + 3);
         Put (N + 5);
         New_Line;
      end if;
   end loop;
end Triplets;
