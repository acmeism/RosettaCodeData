function list = knuthShuffle(list)

    for i = (numel(list):-1:2)

        j = floor(i*rand(1) + 1); %Generate random int between 1 and i

        %Swap element i with element j.
        list([j i]) = list([i j]);
    end
end
