procedure insert_link( a, b, c: link_ptr );
begin
  a^.next := c;
  if b <> nil then b^.prev := c;
  c^.next := b;
  c^.prev := a;
end;
