with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

procedure Sexy_primes is
   N_Down : Natural   := 0; -- 6N-1 length
   N_Up   : Natural   := 0; -- 6N+1 length
   Total  : Natural   := 2; -- Total primes (counting 2 and 3)
   Unsexy : Natural   := 2; -- Total unsexy (counting 2 and 3)

   type Ten is mod 10;
   U : array (Ten) of Half_Word := (2, 3, others => 0);

   type Five is mod 5;
   S : array (2..5, Five) of Half_Word := (others => (others => 0));
   C : array (2..5) of Natural := (others => 0);

   procedure Check (P : Half_Word; Count : in out Natural) is
   begin
      if Is_Prime (P) = Prime then
         Count := Count + 1;
         Total := Total + 1;
         for I in 2..Count loop
            S (I, Five (C (I) mod 5)) := P;
            C (I) := C (I) + 1;
         end loop;
      else
         if Count = 1 then
            U (Ten (Unsexy mod 10)) := P - 6;
            Unsexy := Unsexy + 1;
         end if;
         Count := 0;
      end if;
   end Check;

   procedure Put (Text : String; Length : Positive) is
      Count : constant Natural := C (Length);
   begin
      Put_Line (Text & Integer'Image (Count));
      for I in Count - 5..Count - 1 loop
         declare
            Last : constant Half_Word := S (Length, Five (I mod 5));
         begin
            if Last > 0 then
               for J in reverse Half_Word
                        range 0..Half_Word (Length) - 1 loop
                  Put (Half_Word'Image (Last - J * 6));
               end loop;
               New_Line;
            end if;
         end;
      end loop;
   end Put;

   P : Half_Word := 6;
begin
   for N in Half_Word range 1..Half_Word'Last loop
      exit when P >= 1_000_035 + 1;
      Check (P - 1, N_Down);
      exit when P >= 1_000_035 - 1;
      Check (P + 1, N_Up);
      P := P + 6;
   end loop;
   Put_Line ("Primes:" & Integer'Image (Total));
   Put_Line ("Unsexy," & Integer'Image (Unsexy));
   for I in Unsexy - 10..Unsexy - 1 loop
      Put (Half_Word'Image (U (Ten (I mod 10))));
   end loop;
   New_Line;
   Put ("Pairs,",    2);
   Put ("Triplets,", 3);
   Put ("Quartets,", 4);
   Put ("Quintets,", 5);
end Sexy_Primes;
