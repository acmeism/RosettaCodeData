function list = combSort(list)

    listSize = numel(list);
    gap = int32(listSize); %Coerce gap to an int so we can use the idivide function
    swaps = true; %Swap flag

    while not((gap <= 1) && (swaps == false))

        gap = idivide(gap,1.25,'floor'); %Int divide, floor the resulting operation

        if gap < 1
            gap = 1;
        end

        i = 1; %i equals 1 because all arrays are 1 based in MATLAB
        swaps = false;

        %i + gap must be subtracted by 1 because the pseudo-code was writen
        %for 0 based arrays
        while not((i + gap - 1) >= listSize)

            if (list(i) > list(i+gap))
                list([i i+gap]) = list([i+gap i]); %swap
                swaps = true;
            end
        i = i + 1;

        end %while
    end %while
end %combSort
