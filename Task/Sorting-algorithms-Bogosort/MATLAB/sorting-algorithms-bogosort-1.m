function list = bogoSort(list)
    while( ~issorted(list) ) %Check to see if it is sorted
        list = list( randperm(numel(list)) ); %Randomly sort the list
    end
end
