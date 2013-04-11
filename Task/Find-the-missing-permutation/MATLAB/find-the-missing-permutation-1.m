function perm = findMissingPerms(list)

    permsList = perms(list(1,:)); %Generate all permutations of the 4 letters
    perm = []; %This is the functions return value if the list is not missing a permutation

    %Normally the rest of this would be vectorized, but because this is
    %done on a vector of strings, the vectorized functions will only access
    %one character at a time. So, in order for this to work we have to use
    %loops.
    for i = (1:size(permsList,1))

        found = false;

        for j = (1:size(list,1))
            if (permsList(i,:) == list(j,:))
                found = true;
                break
            end
        end

        if not(found)
            perm = permsList(i,:);
            return
        end

    end %for
end %fingMissingPerms
