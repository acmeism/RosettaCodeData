procedure Make_List is
   Link_Access : A, B, C;
begin
   A := new Link;
   B := new Link;
   C := new Link;
   A.Data := 1;
   B.Data := 2;
   C.Data := 2;
   Insert(Anchor => A, New_Link => B); -- The list is (A, B)
   Insert(Anchor => A, New_Link => C); -- The list is (A, C, B)
end Make_List;
