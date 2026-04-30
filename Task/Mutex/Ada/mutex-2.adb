protected body Mutex is
   entry Seize when not Owned is
   begin
      Owned := True;
   end Seize;
   procedure Release is
   begin
      Owned := False;
   end Release;
end Mutex;
