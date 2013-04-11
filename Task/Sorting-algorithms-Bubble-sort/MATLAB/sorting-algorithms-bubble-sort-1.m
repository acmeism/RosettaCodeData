function list = bubbleSort(list)

    hasChanged = true;
    itemCount = numel(list);

    while(hasChanged)

        hasChanged = false;
        itemCount = itemCount - 1;

        for index = (1:itemCount)

            if(list(index) > list(index+1))
                list([index index+1]) = list([index+1 index]); %swap
                hasChanged = true;
            end %if

        end %for
    end %while
end %bubbleSort
