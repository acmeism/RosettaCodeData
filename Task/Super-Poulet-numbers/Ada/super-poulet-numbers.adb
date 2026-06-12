with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Superpoulet is
   Found   : Natural := 0;
   Got_1M  : Boolean := False;
   Got_10M : Boolean := False;

   procedure Check (N : Half_Word) is
      P : Unbounded_Unsigned := From_Half_Word (N);
   begin
      if Is_Prime (P, 10) /= Prime        and then
         Is_One (Mod_Pow (Two, P - 1, P)) and then
         Is_Two (Mod_Pow (Two, P, P))         then
         declare
            D : Half_Word := 2;
         begin
            While D * D <= N loop
               if N mod D = 0 Then
                  if not Is_Two
                         (  Mod_Pow
                            (  Two,
                               From_Half_Word (D),
                               From_Half_Word (D)
                         )  )  then
                     return;
                  end if;
                  if N / D /= D then
                     if not Is_Two
                            (  Mod_Pow
                               (  Two,
                                  From_Half_Word (N / D),
                                  From_Half_Word (N / D)
                            )  )  then
                        return;
                     end if;
                  end if;
               end if;
               D := D + 1;
            end loop;
            Found := Found + 1;
            if Found <= 20 then
               Put (Integer'Image (Integer (N)));
            elsif not Got_1M and then N > 1_000_000 then
               Got_1M := True;
               New_Line;
               Put (Integer'Image (Integer (N)));
               Put (" #" & Integer'Image (Integer (Found)));
            elsif not Got_10M and then N > 10_000_000 then
               Got_10M := True;
               New_Line;
               Put (Integer'Image (Integer (N)));
               Put (" #" & Integer'Image (Integer (Found)));
            end if;
         end;
      end if;
   end Check;
begin
   for I in Half_Word range 1..Half_Word'Last loop
      Check (I * 6 - 1);
      exit when Got_10M;
      Check (I * 6 + 1);
      exit when Got_10M;
   end loop;
end Superpoulet;
