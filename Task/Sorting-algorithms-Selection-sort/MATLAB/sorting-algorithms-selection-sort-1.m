function list = selectionSort(list)

    listSize = numel(list);

    for i = (1:listSize-1)

        minElem = list(i);
        minIndex = i;

        %This for loop can be vectorized, but there will be no significant
        %increase in sorting efficiency.
        for j = (i:listSize)
            if list(j) <= minElem
                minElem = list(j);
                minIndex = j;
            end
        end

        if i ~= minIndex
            list([minIndex i]) = list([i minIndex]); %Swap
        end

    end %for
end %selectionSort
