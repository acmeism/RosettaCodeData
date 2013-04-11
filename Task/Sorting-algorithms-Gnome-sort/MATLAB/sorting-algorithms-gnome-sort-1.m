function list = gnomeSort(list)

    i = 2;
    j = 3;

    while i <= numel(list)

        if list(i-1) <= list(i)
            i = j;
            j = j+1;
        else
            list([i-1 i]) = list([i i-1]); %Swap
            i = i-1;
            if i == 1
                i = j;
                j = j+1;
            end
        end %if

    end %while
end %gnomeSort
