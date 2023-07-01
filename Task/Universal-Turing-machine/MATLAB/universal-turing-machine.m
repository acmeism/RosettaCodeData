function tape=turing(rules,tape,initial,terminal)
    %"rules" is cell array of cell arrays of the following form:
    %First element is number representing initial state
    %Second element is number representing input from the tape
    %Third element is number representing output printed onto the tape
    %Fourth element is 'l', 'r', or 's' representing whether to go right,
    %left, or stay. Treats any input other than 'l' or 'r' as 's'.
    %Final value is state we go to
    %0 is always blank symbol
    term=0;
    ind=1;
    while term==0
        a=[];
        for i=1:numel(rules)
            if rules{i}{1}==initial
                a=[a i];
            end
        end

        possible=rules(a);
        n=numel(possible);

        while numel(tape)<ind
            tape=[tape, 0]; %#ok<AGROW>
        end

        for i=1:n
            if(tape(ind)==possible{i}{2})
                break;
            end
        end
        instruction=possible{i};
        tape(ind)=instruction{3};
        if instruction{4}=='r'
            ind=ind+1;
        elseif instruction{4}=='l'
            if ind==1
                tape=[0,tape]; %#ok<AGROW>
            else
                ind=ind-1;
            end
        end
        if terminal==instruction{5}
            term=1;
        else
            initial=instruction{5};
        end
    end
end
