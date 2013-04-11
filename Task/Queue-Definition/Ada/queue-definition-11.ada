package body Asynchronous_Fifo is

   ----------
   -- Fifo --
   ----------

   protected body Fifo is

      ----------
      -- Push --
      ----------

      procedure Push (Item : Element_Type) is
      begin
          Value := Item;
         Valid := True;
      end Push;

      ---------
      -- Pop --
      ---------

      entry Pop (Item : out Element_Type) when Valid is
      begin
         Item := Value;
      end Pop;

   end Fifo;

end Asynchronous_Fifo;
