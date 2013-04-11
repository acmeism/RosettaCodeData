package Semaphores is
   protected type Counting_Semaphore(Max : Positive) is
      entry Acquire;
      procedure Release;
      function Count return Natural;
   private
      Lock_Count : Natural := 0;
   end Counting_Semaphore;
end Semaphores;
