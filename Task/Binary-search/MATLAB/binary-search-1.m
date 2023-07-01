function mid = binarySearchRec(list,value,low,high)

    if( high < low )
        mid = [];
        return
    end

    mid = floor((low + high)/2);

    if( list(mid) > value )
        mid = binarySearchRec(list,value,low,mid-1);
        return
    elseif( list(mid) < value )
        mid = binarySearchRec(list,value,mid+1,high);
        return
    else
        return
    end

end
