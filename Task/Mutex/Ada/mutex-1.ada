protected type Mutex is
   entry Seize;
   procedure Release;
private
   Owned : Boolean := False;
end Mutex;
