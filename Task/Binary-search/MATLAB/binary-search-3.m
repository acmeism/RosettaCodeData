function mid = binarySearchIter(list,value)

    low = 1;
    high = numel(list) - 1;

    while( low <= high )
        mid = floor((low + high)/2);

        if( list(mid) > value )
            high = mid - 1;
        elseif( list(mid) < value )
        	low = mid + 1;
        else
            return
        end
    end

    mid = [];

end
