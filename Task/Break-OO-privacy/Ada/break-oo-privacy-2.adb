with OO_Privacy, Ada.Unchecked_Conversion, Ada.Text_IO;

procedure OO_Break_Privacy is

   type Hacker_Stuff is tagged record
      Password: OO_Privacy.Password_Type := "?unknown";
   end record;

   function Hack is new Ada.Unchecked_Conversion
     (Source => OO_Privacy.Confidential_Stuff,     Target => Hacker_Stuff);

   C: OO_Privacy.Confidential_Stuff; -- which password is hidden inside C?

begin
   Ada.Text_IO.Put_Line("The secret password is """ & Hack(C).Password & """");
end OO_Break_Privacy;
