package body Curry_3 is

    package body Apply_1 is

        package body Apply_2 is

            function Apply_3
                   (Third : in Argument_3)
                return Return_Value is
            begin
                return Func (First, Second, Third);
            end Apply_3;

        end Apply_2;

    end Apply_1;

end Curry_3;
