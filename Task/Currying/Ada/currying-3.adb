with Curry_3, Ada.Text_IO;

procedure Curry_Test is

    function Sum
           (X, Y, Z : in Integer)
        return Integer is
    begin
        return X + Y + Z;
    end Sum;

    package Curried is new Curry_3
       (Argument_1   => Integer,
        Argument_2   => Integer,
        Argument_3   => Integer,
        Return_Value => Integer,
        Func         => Sum);

    package Sum_5 is new Curried.Apply_1 (5);
    package Sum_5_7 is new Sum_5.Apply_2 (7);
    Result : Integer := Sum_5_7.Apply_3 (3);

begin

    Ada.Text_IO.Put_Line ("Five plus seven plus three is" & Integer'Image (Result));

end Curry_Test;
