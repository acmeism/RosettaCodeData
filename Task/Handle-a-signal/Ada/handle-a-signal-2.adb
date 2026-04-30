package body Sigint_Handler is

   -------------
   -- Handler --
   -------------

   protected body Handler is

      ----------
      -- Wait --
      ----------

      entry Wait when Call_Count > 0 is
      begin
         Call_Count := Call_Count - 1;
      end Wait;

      ------------
      -- Handle --
      ------------

      procedure Handle is
      begin
         Call_Count := Call_Count + 1;
      end Handle;

   end Handler;

end Sigint_Handler;
