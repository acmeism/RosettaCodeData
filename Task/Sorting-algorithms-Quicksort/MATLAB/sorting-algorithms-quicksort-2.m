function sortedArray = quickSort(array)

    if numel(array) <= 1 %If the array has 1 element then it can't be sorted
        sortedArray = array;
        return
    end

    pivot = array(end);
    array(end) = [];

    sortedArray = [quickSort( array(array <= pivot) ) pivot quickSort( array(array > pivot) )];

end
