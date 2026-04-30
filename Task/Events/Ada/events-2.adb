protected body Event is
   procedure Signal is
   begin
      Fired := True;
   end Signal;
   procedure Reset is
   begin
      Fired := False;
   end Reset;
   entry Wait when Fired is
   begin
      null;
   end Wait;
end Event;
