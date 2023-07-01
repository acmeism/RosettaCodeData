package body OO_Privacy.Friend is -- implementation of the child package

  function Get_Password(Secret: Confidential_Stuff) return String is
    (Secret.Password);

end OO_Privacy.Friend;
