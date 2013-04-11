function sortedArray = quickSort(array)

    if numel(array) <= 1 %If the array has 1 element then it can't be sorted
        sortedArray = array;
        return
    end

    pivot = array(end);
    array(end) = [];

    %Create two new arrays which contain the elements that are less than or
    %equal to the pivot called "less" and greater than the pivot called
    %"greater"
    less = array( array <= pivot );
    greater = array( array > pivot );

    %The sorted array is the concatenation of the sorted "less" array, the
    %pivot and the sorted "greater" array in that order
    sortedArray = [quickSort(less) pivot quickSort(greater)];

end
