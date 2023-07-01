classdef RingInt

    properties
        value
    end

    methods

        %RingInt constructor
        function theInt = RingInt(varargin)
            if numel(varargin) == 0
                theInt.value = 1;
            elseif numel(varargin) > 1
                error 'The RingInt constructor can''''t take more than 1 argument.';
            else

                %Makes sure any doubles are coerced to ints
                if not(isinteger(varargin{1}))
                    varargin{1} = int32(varargin{1});
                end

                %Maps out of bound values to the proper range
                if varargin{1} > 10
                    theInt.value = varargin{1} - (10 * (idivide(varargin{1},10,'ceil') - 1));
                elseif varargin{1} < 1
                    theInt.value = varargin{1} + (10 * (idivide(abs(varargin{1}),10,'floor') + 1));
                else
                    theInt.value = varargin{1};
                end
            end
        end %constructor

        %Overload the "+" operator
        function sum = plus(firstNumber,secondNumber)

            if isa(firstNumber,'RingInt') && isa(secondNumber,'RingInt')
                sum = firstNumber.value + secondNumber.value;
            elseif isa(firstNumber,'RingInt') && not(isa(secondNumber,'RingInt'))
                sum = firstNumber.value + secondNumber;
            else
                sum = secondNumber.value + firstNumber;
            end

            sum = RingInt(sum);

        end %+

        %Overload the "-" operator
        function difference = minus(firstNumber,secondNumber)

            if isa(firstNumber,'RingInt') && isa(secondNumber,'RingInt')
                difference = firstNumber.value - secondNumber.value;
            elseif isa(firstNumber,'RingInt') && not(isa(secondNumber,'RingInt'))
                difference = firstNumber.value - secondNumber;
            else
                difference = firstNumber - secondNumber.value;
            end

            difference = RingInt(difference);

        end %-

        %Overload the "==" operator
        function trueFalse = eq(firstNumber,secondNumber)

            if isa(firstNumber,'RingInt') && isa(secondNumber,'RingInt')
                trueFalse = firstNumber.value == secondNumber.value;
            else
                error 'You can only compare a RingInt to another RingInt';
            end

        end %==


        %Overload the display() function
        function display(ringInt)
            disp(ringInt);
        end

        %Overload the disp() function
        function disp(ringInt)
            disp(sprintf('\nans =\n\n\t %d\n',ringInt.value));
        end

    end %methods
end %classdef
