declare
   M : Mutex;
begin
   M.Seize;    -- Wait infinitely for the mutex to be free
   ...         -- Critical code
   M.Release;  -- Release the mutex
   ...
   select
      M.Seize; -- Wait no longer than 0.5s
   or delay 0.5;
      raise Timed_Out;
   end select;
   ...         -- Critical code
   M.Release;  -- Release the mutex
end;
