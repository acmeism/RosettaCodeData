package OO_Privacy is

   type Confidential_Stuff is tagged private;
   subtype Password_Type is String(1 .. 8);

private
   type Confidential_Stuff is tagged record
      Password: Password_Type := "default!"; -- the "secret"
   end record;
end OO_Privacy;
