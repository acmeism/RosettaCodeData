function [S,v] = fourBitAdder(input1,input2)

    %Make sure that only 4-Bit numbers are being added. This assumes that
    %if input1 and input2 are a vector of multiple decimal numbers, then
    %the binary form of these vectors are an n by 4 matrix.
    assert((size(input1,2) == 4) && (size(input2,2) == 4),'This will only work on 4-Bit Numbers');

    %Converts MATLAB binary strings to matricies of 1 and 0
    function mat = binStr2Mat(binStr)
        mat = zeros(size(binStr));
        for i = (1:numel(binStr))
            mat(i) = str2double(binStr(i));
        end
    end

    %XOR decleration
    function AxorB = xor(A,B)
        AxorB = or(and(A,not(B)),and(B,not(A)));
    end

    %Half-Adder decleration
    function [S,C] = halfAdder(A,B)
        S = xor(A,B);
        C = and(A,B);
    end

    %Full-Adder decleration
    function [S,Co] = fullAdder(A,B,Ci)
       [SAdder1,CAdder1] = halfAdder(Ci,A);
       [S,CAdder2] = halfAdder(SAdder1,B);
       Co = or(CAdder1,CAdder2);
    end

    %The rest of this code is the 4-bit adder

    binStrFlag = false; %A flag to determine if the original input was a binary string

    %If either of the inputs was a binary string, convert it to a matrix of
    %1's and 0's.
    if ischar(input1)
       input1 = binStr2Mat(input1);
       binStrFlag = true;
    end
    if ischar(input2)
       input2 = binStr2Mat(input2);
       binStrFlag = true;
    end

    %This does the addition
    S = zeros(size(input1));

    [S(:,4),Co] = fullAdder(input1(:,4),input2(:,4),0);
    [S(:,3),Co] = fullAdder(input1(:,3),input2(:,3),Co);
    [S(:,2),Co] = fullAdder(input1(:,2),input2(:,2),Co);
    [S(:,1),v] = fullAdder(input1(:,1),input2(:,1),Co);

    %If the original inputs were binary strings, convert the output of the
    %4-bit adder to a binary string with the same formatting as the
    %original binary strings.
    if binStrFlag
        S = num2str(S);
        v = num2str(v);
    end
end %fourBitAdder
