procedure Insert (Anchor : Link_Access; New_Link : Link_Access) is
begin
   if Anchor /= Null and New_Link /= Null then
      New_Link.Next := Anchor.Next;
      New_Link.Prev := Anchor;
      if New_Link.Next /= Null then
         New_Link.Next.Prev := New_Link;
      end if;
      Anchor.Next := New_Link;
   end if;
end Insert;
