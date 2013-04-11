function list = cocktailSort(list)

    %We have to do this because the do...while loop doesn't exist in MATLAB
    swapped = true;

    while swapped

        %Bubble sort down the list
        swapped = false;
        for i = (1:numel(list)-1)
            if( list(i) > list(i+1) )
                list([i i+1]) = list([i+1 i]); %swap
                swapped = true;
            end
        end

        if ~swapped
            break
        end

        %Bubble sort up the list
        swapped = false;
        for i = (numel(list)-1:-1:1)
            if( list(i) > list(i+1) )
                list([i i+1]) = list([i+1 i]); %swap
                swapped = true;
            end %if
        end %for
    end %while
end %cocktail sort
