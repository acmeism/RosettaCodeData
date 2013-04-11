function list = heapSort(list)

    function list = siftDown(list,root,theEnd)
        while (root * 2) <= theEnd

            child = root * 2;
            if (child + 1 <= theEnd) && (list(child) < list(child+1))
                child = child + 1;
            end

            if list(root) < list(child)
                list([root child]) = list([child root]); %Swap
                root = child;
            else
                return
            end

        end %while
    end %siftDown

    count = numel(list);

    %Because heapify is called once in pseudo-code, it is inline here
    start = floor(count/2);

    while start >= 1
        list = siftDown(list, start, count);
        start = start - 1;
    end
    %End Heapify

    while count > 1

        list([count 1]) = list([1 count]); %Swap
        count = count - 1;
        list = siftDown(list,1,count);

    end

end
