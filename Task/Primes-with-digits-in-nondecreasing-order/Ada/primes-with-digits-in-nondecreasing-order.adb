with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

procedure Primes_with_Nondecreasing_Digits is

   procedure Check (P : Half_Word) is
   begin
      if Is_Prime (P) = Prime then
         declare
            Value   : Half_Word := P / 10;
            Last    : Half_Word := P mod 10;
            Current : Half_Word;
         begin
            while Value > 0 loop
               Current := Value mod 10;
               if Current > Last then
                  return;
               end if;
               Last  := Current;
               Value := Value / 10;
            end loop;
            Put (Half_Word'Image (P));
         end;
      end if;
   end Check;
begin
   Put ("2 3");
   for I in Half_Word range 1..167 loop
      Check (I * 6 - 1);
      Check (I * 6 + 1);
   end loop;
end Primes_with_Nondecreasing_Digits;
