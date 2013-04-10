function [A,G,H] = pythagoreanMeans(list)
    A = mean(list);           % arithmetic mean
    G = exp(mean(log(list))); % geometric mean
    H = 1./mean(1./list);     % harmonic mean
end
