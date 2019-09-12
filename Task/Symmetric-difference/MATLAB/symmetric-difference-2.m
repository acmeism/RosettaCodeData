function resultantSet = symmetricDifference(set1,set2)

    assert( ~xor(iscell(set1),iscell(set2)), 'Both sets must be of the same type, either cells or matricies, but not a combination of the two' );
%% Helper function definitions

    %Define what set equality means for cell arrays
    function trueFalse = equality(set1,set2)
        if xor(iscell(set1),iscell(set2)) %set1 or set2 is a set and the other isn't
            trueFalse = false;
            return
        elseif ~(iscell(set1) || iscell(set2)) %set1 and set2 are not sets
            if ischar(set1) && ischar(set2) %set1 and set2 are chars or strings
                trueFalse = strcmp(set1,set2);
            elseif xor(ischar(set1),ischar(set2)) %set1 or set2 is a string but the other isn't
                trueFalse = false;
            else %set1 and set2 are not strings
                if numel(set1) == numel(set2) %Since they must be matricies if the are of equal cardinality then they can be compaired
                    trueFalse = all((set1 == set2));
                else %If they aren't of equal cardinality then they can't be equal
                    trueFalse = false;
                end
            end
            return
        else %set1 and set2 are both sets

            for x = (1:numel(set1))
                trueFalse = false;
                for y = (1:numel(set2))

                    %Compair the current element of set1 with every element
                    %in set2
                    trueFalse = equality(set1{x},set2{y});

                    %If the element of set1 is equal to the current element
                    %of set2 remove that element from set2 and break out of
                    %this inner loop
                    if trueFalse
                        set2(y) = [];
                        break
                    end
                end

                %If the loop completes without breaking then the current
                %element of set1 is not contained in set2 therefore the two
                %sets are not equal and we can return an equality of false
                if (~trueFalse)
                    return
                end
            end

            %If, after checking every element in both sets, there are still
            %elements in set2 then the two sets are not equivalent
            if ~isempty(set2)
                trueFalse = false;
            end
            %If the executation makes it here without the previous if
            %statement evaluating to true, then this function will return
            %true.
        end
    end %equality

    %Define the relative complement for cell arrays
    function set1 = relativeComplement(set1,set2)

        for k = (1:numel(set2))

            if numel(set1) == 0
                return
            end

            j = 1;
            while j <= numel(set1)
                if equality(set1{j},set2{k})
                    set1(j) = [];
                    j = j-1;
                end
                j = j+1;
            end
        end
    end %relativeComplement

%% The Symmetric Difference Algorithm
    if iscell(set1) && iscell(set2)
        resultantSet = [relativeComplement(set1,set2) relativeComplement(set2,set1)];
    else
        resultantSet = [setdiff(set1,set2) setdiff(set2,set1)];
    end

    resultantSet = unique(resultantSet); %Make sure there are not duplicates

end %symmetricDifference
