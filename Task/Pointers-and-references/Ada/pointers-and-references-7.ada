type Container is array (Positive range <>) of Element;
for I in Container'Range loop
   declare
      Item : Element renames Container (I);
   begin
      Do_Something(Item); -- Here Item is a reference to Container (I)
   end;
end loop;
