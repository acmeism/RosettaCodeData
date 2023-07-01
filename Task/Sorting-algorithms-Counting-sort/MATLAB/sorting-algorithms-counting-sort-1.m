function list = countingSort(list)

    minElem = min(list);
    maxElem = max(list);

    count = zeros((maxElem-minElem+1),1);

    for number = list
        count(number - minElem + 1) = count(number - minElem + 1) + 1;
    end

    z = 1;

    for i = (minElem:maxElem)
        while( count(i-minElem +1) > 0)
            list(z) = i;
            z = z+1;
            count(i - minElem + 1) = count(i - minElem + 1) - 1;
        end
    end

end %countingSort
