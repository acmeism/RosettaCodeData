with Semaphores;
with Ada.Text_Io; use Ada.Text_Io;

procedure Semaphores_Main is
   -- Create an instance of a Counting_Semaphore with Max set to 3
   Lock : Semaphores.Counting_Semaphore(3);

   -- Define a task type to interact with the Lock object declared above
   task type Worker is
      entry Start (Sleep : in Duration; Id : in Positive);
   end Worker;

   task body Worker is
      Sleep_Time : Duration;
      My_Id : Positive;
   begin
      accept Start(Sleep : in Duration; Id : in Positive) do
         My_Id := Id;
         Sleep_Time := Sleep;
      end Start;
      --Acquire the lock. The task will suspend until the Acquire call completes
      Lock.Acquire;
      Put_Line("Task #" & Positive'Image(My_Id) & " acquired the lock.");
      -- Suspend the task for Sleep_Time seconds
      delay Sleep_Time;
      -- Release the lock. Release is unconditional and happens without suspension
      Lock.Release;
   end Worker;

   -- Create an array of 5 Workers
   type Staff is array(Positive range 1..5) of Worker;
   Crew : Staff;
begin
   for I in Crew'range loop
      Crew(I).Start(2.0, I);
   end loop;
end Semaphores_Main;
