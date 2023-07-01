package Synchronous_Concurrent is
   task Printer is
      entry Put(Item : in String);
      entry Get_Count(Count : out Natural);
   end Printer;
end Synchronous_Concurrent;
