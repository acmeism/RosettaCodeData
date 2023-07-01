with OO_Privacy.Friend, Ada.Text_IO;

procedure Bypass_OO_Privacy is

  C: OO_Privacy.Confidential_Stuff; -- which password is hidden inside C?

begin
  Ada.Text_IO.Put_Line("Password: """ &
                       OO_Privacy.Friend.Get_Password(C) &
                       """");
end Bypass_OO_Privacy;
