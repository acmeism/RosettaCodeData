function list = permutationSort(list)

    permutations = perms(1:numel(list)); %Generate all permutations of the item indicies

    %Test every permutation of the indicies of the original list
    for i = (1:size(permutations,1))
        if issorted( list(permutations(i,:)) )
            list = list(permutations(i,:));
            return %Once the correct permutation of the original list is found break out of the program
        end
    end

end
