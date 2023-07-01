function list = insertionSort(list)

    for i = (2:numel(list))

        value = list(i);
        j = i - 1;

        while (j >= 1) && (list(j) > value)
            list(j+1) = list(j);
            j = j-1;
        end

        list(j+1) = value;

    end %for
end %insertionSort
