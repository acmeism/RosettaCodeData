package body Synchronous_Fifo is

   ----------
   -- Fifo --
   ----------

   protected body Fifo is

      ---------
      -- Push --
      ---------

      entry Push (Item : Element_Type) when not Is_New is
      begin
         Value := Item;
         Is_New := True;
      end Push;

      ---------
      -- Pop --
      ---------

      entry Pop (Item : out Element_Type) when Is_New is
      begin
         Item := Value;
         Is_New := False;
      end Pop;

   end Fifo;

end Synchronous_Fifo;
