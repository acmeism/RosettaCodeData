protected type Event is
   procedure Signal;
   procedure Reset;
   entry Wait;
private
   Fired : Boolean := False;
end Event;
