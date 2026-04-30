package body Semaphores is

   ------------------------
   -- Counting_Semaphore --
   ------------------------

   protected body Counting_Semaphore is

      -------------
      -- Acquire --
      -------------

      entry Acquire when Lock_Count < Max is
      begin
         Lock_Count := Lock_Count + 1;
      end Acquire;

      -----------
      -- Count --
      -----------

      function Count return Natural is
      begin
         return Lock_Count;
      end Count;

      -------------
      -- Release --
      -------------

      procedure Release is
      begin
         if Lock_Count > 0 then
            Lock_Count := Lock_Count - 1;
         end if;
      end Release;

   end Counting_Semaphore;

end Semaphores;
