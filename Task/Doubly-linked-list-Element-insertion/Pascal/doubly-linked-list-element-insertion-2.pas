procedure realistic_insert_link( a, c: link_ptr );
begin
  if a^.next <> nil then a^.next^.prev := c;  (* 'a^.next^' is another way of saying 'b', if b exists *)
  c^.next := a^.next;
  a^.next := c;
  c^.prev := a;
end;
