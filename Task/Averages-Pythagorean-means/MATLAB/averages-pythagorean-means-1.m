function [A,G,H] = pythagoreanMeans(list)

    A = mean(list);
    G = geomean(list);
    H = harmmean(list);

end
