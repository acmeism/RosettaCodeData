% Is string numeric?

function [out] = str_isnumeric(string)

    if ~ischar(string)
        error('str_isnumeric:NonCharacterArray','not a string input');
    end

    Nd = sum(isstrprop(string,'digit'));
    Nc = length(string);

    dN = Nc - Nd;

    switch dN
        case 0
            out = 1;
        otherwise
            out = 0;
    end
end
