function list = mergeSort(list)

    if numel(list) <= 1
        return
    else
        middle = ceil(numel(list) / 2);
        left = list(1:middle);
        right = list(middle+1:end);

        left = mergeSort(left);
        right = mergeSort(right);

        if left(end) <= right(1)
            list = [left right];
            return
        end

        %merge(left,right)
        counter = 1;
        while (numel(left) > 0) && (numel(right) > 0)
            if(left(1) <= right(1))
                list(counter) = left(1);
                left(1) = [];
            else
                list(counter) = right(1);
                right(1) = [];
            end
            counter = counter + 1;
        end

        if numel(left) > 0
            list(counter:end) = left;
        elseif numel(right) > 0
            list(counter:end) = right;
        end
        %end merge
    end %if
end %mergeSort
