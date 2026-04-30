with Ada.Wide_Wide_Text_IO;  use Ada.Wide_Wide_Text_IO;

procedure Test is
begin
   Put ("Unicode """ & ''' & """" & Wide_Wide_Character'Val (10));
end Test;
