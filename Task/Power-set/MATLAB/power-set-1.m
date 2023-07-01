function pset = powerset(theSet)

    pset = cell(size(theSet)); %Preallocate memory

    %Generate all numbers from 0 to 2^(num elements of the set)-1
    for i = ( 0:(2^numel(theSet))-1 )

        %Convert i into binary, convert each digit in binary to a boolean
        %and store that array of booleans
        indicies = logical(bitget( i,(1:numel(theSet)) ));

        %Use the array of booleans to extract the members of the original
        %set, and store the set containing these members in the powerset
        pset(i+1) = {theSet(indicies)};

    end

end
