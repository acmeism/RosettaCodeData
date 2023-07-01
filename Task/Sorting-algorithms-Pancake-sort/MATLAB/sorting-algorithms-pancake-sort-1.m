function list = pancakeSort(list)

    for i = (numel(list):-1:2)

        minElem = list(i);
        minIndex = i;

        %Find the min element in the current subset of the list
        for j = (i:-1:1)
            if list(j) <= minElem
                minElem = list(j);
                minIndex = j;
            end
        end

        %If the element is already in the correct position don't flip
        if i ~= minIndex

            %First flip flips the min element in the stack to the top
            list(minIndex:-1:1) = list(1:minIndex);

            %Second flip flips the min element into the correct position in
            %the stack
            list(i:-1:1) = list(1:i);

        end
    end %for
end %pancakeSort
