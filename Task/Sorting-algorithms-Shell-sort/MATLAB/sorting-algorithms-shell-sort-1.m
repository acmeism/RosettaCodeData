function list = shellSort(list)

    N = numel(list);
    increment = round(N/2);

    while increment > 0

        for i = (increment+1:N)
            temp = list(i);
            j = i;
            while (j >= increment+1) && (list(j-increment) > temp)
                list(j) = list(j-increment);
                j = j - increment;
            end

            list(j) = temp;

        end %for

        if increment == 2 %This case causes shell sort to become insertion sort
            increment = 1;
        else
            increment = round(increment/2.2);
        end
    end %while
end %shellSort
