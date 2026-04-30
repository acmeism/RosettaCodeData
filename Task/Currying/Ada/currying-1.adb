generic
    type Argument_1 (<>) is limited private;
    type Argument_2 (<>) is limited private;
    type Argument_3 (<>) is limited private;
    type Return_Value (<>) is limited private;

    with function Func
           (A : in Argument_1;
            B : in Argument_2;
            C : in Argument_3)
        return Return_Value;
package Curry_3 is

    generic
        First : in Argument_1;
    package Apply_1 is

        generic
            Second : in Argument_2;
        package Apply_2 is

            function Apply_3
                   (Third : in Argument_3)
                return Return_Value;

        end Apply_2;

    end Apply_1;

end Curry_3;
