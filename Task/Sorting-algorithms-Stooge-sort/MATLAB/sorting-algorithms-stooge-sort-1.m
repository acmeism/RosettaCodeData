%Required inputs:
%i = 1
%j = length(list)
%
function list = stoogeSort(list,i,j)

    if list(j) < list(i)
        list([i j]) = list([j i]);
    end

    if (j - i) > 1
        t = round((j-i+1)/3);
        list = stoogeSort(list,i,j-t);
        list = stoogeSort(list,i+t,j);
        list = stoogeSort(list,i,j-t);
    end

end
