type Link is limited record
   Next : not null access Link := Link'Unchecked_Access;
   Prev : not null access Link := Link'Unchecked_Access;
   Data : Integer;
end record;
