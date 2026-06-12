package body Brent is
   procedure Brent (F : Brent_Function; X0 : Element_Type; Lambda : out Integer; Mu : out Integer) is
      Power : Integer := 1;
      Tortoise : Element_Type := X0;
      Hare : Element_Type := F(X0);
   begin
      Lambda := 1;
      Mu := 0;
      while Tortoise /= Hare loop
         if Power = Lambda then
            Tortoise := Hare;
            Power := Power * 2;
            Lambda := 0;
         end if;
         Hare := F(Hare);
         Lambda := Lambda + 1;
      end loop;
      Tortoise := X0;
      Hare := X0;
      for I in 0..(Lambda-1) loop
         Hare := F(Hare);
      end loop;
      while Hare /= Tortoise loop
         Tortoise := F(Tortoise);
         Hare := F(Hare);
         Mu := Mu + 1;
      end loop;
   end Brent;
end Brent;
